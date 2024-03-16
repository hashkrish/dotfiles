#!/usr/bin/env sh

active_monitor_id=$(hyprctl activeworkspace -j | jq -r '.monitorID')

get_other_workspace() {
    hyprctl workspaces -j |
        jq -r "[.[]|select(.monitorID != $active_monitor_id)][0]|.id"
}

switch_workspace_id=$(hyprctl clients -j |
    jq "[.[]|select(.monitor != $active_monitor_id)|select(.focusHistoryID != -1)]|sort_by(.focusHistoryID)|.[0]|.workspace.id|if . == null then $(get_other_workspace) else . end")

hyprctl dispatch workspace "$switch_workspace_id"
