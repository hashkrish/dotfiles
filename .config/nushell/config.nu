
# config.nu
#
# Installed by:
# version = "0.103.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

source /home/krishnan/sources/dotfiles/.config/nushell/usr_fn.nu

$env.config.show_banner = false

# Path
$env.PATH = (
  $env.PATH 
  | append /home/krishnan/.local/bin
  | append /home/krishnan/.local/share/pnpm
  | append /home/krishnan/go/bin
  | append /home/krishnan/sources/google-cloud-sdk/bin
  )

# Aliases
export alias l = ^ls --color
export alias ll = ls -l
export alias xc = wl-copy
export alias xo = wl-paste -n


# Atuin
source ~/.local/share/atuin/init.nu

# Theme
# source ~/sources/nu_scripts/themes/nu-themes/tokyo-night.nu
source ~/sources/nu_scripts/themes/nu-themes/one-half-black.nu

# Zoxide
source ~/.zoxide.nu

# Auto-completion
source ~/sources/nu_scripts/custom-completions/docker/docker-completions.nu
source ~/sources/nu_scripts/custom-completions/gcloud/gcloud-completions.nu
source ~/sources/nu_scripts/custom-completions/git/git-completions.nu
source ~/sources/nu_scripts/custom-completions/tar/tar-completions.nu
source ~/sources/nu_scripts/custom-completions/just/just-completions.nu
source ~/sources/nu_scripts/custom-completions/aws/aws-completions.nu
source ~/sources/nu_scripts/custom-completions/cargo/cargo-completions.nu
source ~/sources/nu_scripts/custom-completions/gh/gh-completions.nu
source ~/sources/nu_scripts/custom-completions/curl/curl-completions.nu
source ~/sources/nu_scripts/custom-completions/man/man-completions.nu
source ~/sources/nu_scripts/custom-completions/rg/rg-completions.nu
source ~/sources/nu_scripts/custom-completions/npm/npm-completions.nu
source ~/sources/nu_scripts/custom-completions/pnpm/pnpm-completions.nu
source ~/sources/nu_scripts/custom-completions/pass/pass-completions.nu
source ~/sources/nu_scripts/custom-completions/rg/rg-completions.nu
source ~/sources/nu_scripts/custom-completions/uv/uv-completions.nu





