#!/bin/bash

# Usage: sway-app-switcher.sh <app_id> [class]
# Switch between open applications in Sway/Hyprland using tofi as selector

if [ $# -lt 1 ]; then
    echo "Usage: $0 <app_id> [class]"
    exit 1
fi

APP_ID="$1"
CLASS="$2"

# Detect compositor
if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ] || pgrep -x "Hyprland" > /dev/null 2>&1; then
    COMPOSITOR="hyprland"
elif pgrep -x "sway" > /dev/null 2>&1; then
    COMPOSITOR="sway"
else
    echo "Error: Neither Sway nor Hyprland is running"
    exit 1
fi

if [ "$COMPOSITOR" = "sway" ]; then
    # Get current workspace and output for Sway
    TREE=$(swaymsg -t get_tree -r)
    CURRENT_WORKSPACE=$(echo "$TREE" | jq -r '.. | select(.type? == "workspace" and .focused? == true) | .name')
    CURRENT_OUTPUT=$(echo "$TREE" | jq -r '.. | select(.type? == "output" and .focused? == true) | .name')

    # Get the window tree and filter windows with workspace/output info
    windows=$(echo "$TREE" | jq -r --arg app_id "$APP_ID" --arg class "$CLASS" --arg curr_ws "$CURRENT_WORKSPACE" --arg curr_out "$CURRENT_OUTPUT" '
        [
            .. |
            select(.type? == "output") |
            select(.name != "__i3") |
            {
                output: .name,
                workspaces: [
                    .. |
                    select(.type? == "workspace") |
                    select(.name != "__i3_scratch") |
                    {
                        workspace: .name,
                        windows: [
                            .. |
                            select(.type? == "con" or .type? == "floating_con") |
                            select(.app_id? != null or .window_properties?.class? != null) |
                            select(
                                (.app_id? == $app_id) or
                                (if $class != "" then (.window_properties?.class? == $class) else false end)
                            ) |
                            {
                                id: .id,
                                app_id: .app_id,
                                class: .window_properties?.class,
                                name: .name
                            }
                        ]
                    } |
                    select(.windows | length > 0)
                ]
            } |
            select(.workspaces | length > 0)
        ] |
        .[] | .output as $out | .workspaces[] | .workspace as $ws | .windows[] |

        # Calculate priority
        (if $ws == $curr_ws then 1
         elif $out == $curr_out then 2
         else 3 end) as $priority |

        "\($priority)\t\(.id)\t\(.app_id // .class)\t\(.name)\t[\($ws)]"
    ' | sort -n | cut -f2-)

else
    # Hyprland implementation
    CLIENTS=$(hyprctl clients -j)
    ACTIVE_WORKSPACE=$(hyprctl activeworkspace -j | jq -r '.id')
    ACTIVE_MONITOR=$(hyprctl activeworkspace -j | jq -r '.monitor')

    windows=$(echo "$CLIENTS" | jq -r --arg app_id "$APP_ID" --arg class "$CLASS" --arg curr_ws "$ACTIVE_WORKSPACE" --arg curr_mon "$ACTIVE_MONITOR" '
        .[] |
        select(
            (.class == $app_id) or
            (if $class != "" then (.class == $class) else false end)
        ) |

        # Calculate priority
        (if (.workspace.id | tostring) == $curr_ws then 1
         elif .monitor == $curr_mon then 2
         else 3 end) as $priority |

        "\($priority)\t\(.address)\t\(.class)\t\(.title)\t[\(.workspace.name)]"
    ' | sort -n | cut -f2-)
fi

# Check if any windows were found
if [ -z "$windows" ]; then
    echo "No windows found matching app_id: $APP_ID" $([ -n "$CLASS" ] && echo "or class: $CLASS")
    exit 1
fi

# Use tofi to select a window
selected=$(echo "$windows" | awk -F'\t' '{print $2 " - " $3 " " $4}' | tofi --prompt-text "Select window: ")

if [ -z "$selected" ]; then
    exit 0
fi

# Extract the window ID from the selected line
window_id=$(echo "$windows" | awk -F'\t' -v sel="$selected" '$2 " - " $3 " " $4 == sel {print $1}')

# Focus the selected window
if [ -n "$window_id" ]; then
    if [ "$COMPOSITOR" = "sway" ]; then
        swaymsg "[con_id=$window_id]" focus
    else
        hyprctl dispatch focuswindow "address:$window_id"
    fi
fi
