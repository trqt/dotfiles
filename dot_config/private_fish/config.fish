# Remove gretting message
set fish_greeting  

# Freedesktop-fy home
set -x RUSTUP_HOME $XDG_DATA_HOME/rustup  
set -x CARGO_HOME $XDG_DATA_HOME/cargo
set -x GOPATH $HOME/.local/share/go

# Neovim FTW!
set -x EDITOR "nvim"
set -x VISUAL "nvim"
set -x MANPAGER "nvim +Man!"

set -x LIBVA_DRIVER_NAME "i965"
set -x DOTNET_CLI_TELEMETRY_OPTOUT 1
set -x GOPROXY "direct"
set -x BAT_THEME "gruvbox-dark"

# Wayland
set -x MOZ_ENABLE_WAYLAND 1
set -x SDL_VIDEODRIVER wayland 

set fish_color_normal brwhite 
set fish_color_autosuggestion '#7d7d7d' 
set fish_color_command brcyan 
set fish_color_error '#ff6c6b' 
set fish_color_param bryellow

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

#direnv hook fish | source

