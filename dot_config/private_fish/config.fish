# Remove gretting message
set fish_greeting  

set -x XDG_DATA_HOME $HOME/.local/share
# Freedesktop-fy home
set -x RUSTUP_HOME $XDG_DATA_HOME/rustup  
set -x CARGO_HOME $XDG_DATA_HOME/cargo
set -x GOPATH $XDG_DATA_HOME/go

set -U fish_user_paths $CARGO_HOME/bin $RUSTUP_HOME/bin $fish_user_paths

# Neovim FTW!
set -x EDITOR "nvim"
set -x VISUAL "nvim"
set -x MANPAGER "nvim +Man!"

# Dev
set -x DOTNET_CLI_TELEMETRY_OPTOUT 1
set -x GOPROXY "direct"
set -x RUSTC_WRAPPER "sccache"

# Wayland
set -x MOZ_ENABLE_WAYLAND 1
set -x SDL_VIDEODRIVER wayland 

# Misc
set -x LIBVA_DRIVER_NAME "i965"
set -x BAT_THEME "gruvbox-dark"

set fish_color_normal brwhite 
set fish_color_autosuggestion '#7d7d7d' 
set fish_color_command brcyan 
set fish_color_error '#ff6c6b' 
set fish_color_param bryellow


# Aliases
alias vim="nvim"
alias em="emacsclient -t"
alias zt="zathura"
alias tors="torsocks"

alias ls="exa"

alias cp="cp -iv" 
alias mv="mv -iv" 
alias rm="rm -iv" 

for x in lynx profanity
    alias $x="torsocks $x"
end

for x in mount umount apk ufw
    alias $x="sudo $x"
end

function la --wraps=ls --description 'List contents of directory, including hidden files in directory using long format'
    ls -lah $argv
end

set -g fish_key_bindings fish_vi_key_bindings

if status is-interactive 
    set -gx ATUIN_NOBIND "true"
    atuin init fish | source

    # bind to ctrl-r in normal and insert mode, add any other bindings you want here too
    bind \cr _atuin_search
    bind -M insert \cr _atuin_search
end

# SSH-Agent
if test -z (pgrep ssh-agent | string collect)
    eval (ssh-agent -c)
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
end

direnv hook fish | source

