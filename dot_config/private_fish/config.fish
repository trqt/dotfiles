# Remove gretting message
set fish_greeting  

set -x XDG_DATA_HOME $HOME/.local/share
set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_STATE_HOME $HOME/.local/state
set -x XDG_CACHE_HOME $HOME/.cache
# Freedesktop-fy home
set -x RUSTUP_HOME $XDG_DATA_HOME/rustup  
set -x CARGO_HOME $XDG_DATA_HOME/cargo
set -x GOPATH $XDG_DATA_HOME/go
set -x OPAMROOT $XDG_DATA_HOME/opam
set -x FLYCTL_INSTALL $XDG_DATA_HOME/fly
set -x SQLITE_HISTORY $XDG_CACHE_HOME/sqlite_history
set -x BUNDLE_USER_CONFIG $XDG_CONFIG_HOME/bundle
set -x BUNDLE_USER_CACHE $XDG_CACHE_HOME/bundle
set -x BUNDLE_USER_PLUGIN $XDG_DATA_HOME/bundle
set -x WINEPREFIX $XDG_DATA_HOME/wine
set -x LESSHISTFILE $XDG_CACHE_HOME/less_history
set -x PASSWORD_STORE_DIR $XDG_DATA_HOME/pass
set -x INPUTRC $XDG_CONFIG_HOME/readline/inputrc 
set -x _JAVA_OPTIONS "-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java" 
set -x ANDROID_HOME $XDG_DATA_HOME/android
set -x GDBHISTFILE $XDG_CONFIG_HOME/gdb/.gdb_history 
set -x GNUPGHOME $XDG_DATA_HOME/gnupg
set -x DOT_SAGE $XDG_CONFIG_HOME/sage

set -U fish_user_paths $HOME/.local/bin ~/.nix-profile/bin $CARGO_HOME/bin $RUSTUP_HOME/bin $GOPATH/bin $XDG_DATA_HOME/bob/nvim-bin $FLYCTL_INSTALL/bin $fish_user_paths

# Neovim FTW!
set -x EDITOR "nvim"
set -x VISUAL "nvim"
set -x MANPAGER "nvim +Man!"

# Dev
set -x DOTNET_CLI_TELEMETRY_OPTOUT 1
set -x GOPROXY "direct"
set -x RUSTC_WRAPPER "sccache"
set -x ASAN_SYMBOLIZER_PATH "/usr/bin/llvm-symbolizer"

# Wayland
set -x MOZ_ENABLE_WAYLAND 1
set -x SDL_VIDEODRIVER wayland 

# Misc
set -x LIBVA_DRIVER_NAME "i965"
set -x BAT_THEME "Catppuccin-mocha"

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
alias pgdb="gdb -q -n -x $XDG_CONFIG_HOME/gdb/init"

alias ls="exa"

alias cp="cp -iv" 
alias mv="mv -iv" 
alias rm="rm -iv" 

for x in mount umount apk ufw
    alias $x="sudo $x"
end

function la --wraps=ls --description 'List contents of directory, including hidden files in directory using long format'
    ls -lah $argv
end

function p --description 'Jumps to a project'
    set -l proj_dir $HOME/dev
    set -l project $(ls $proj_dir | fzf --prompt "Switch to project: ")
    cd $proj_dir/$project
    tmux new -s $project
end

function a --description 'Attach to session'
    set -l sessions (tmux list-sessions | fzf --prompt "Active sessions: ")
    set -l session (echo $sessions | cut -d' ' -f1 | tr -d ":")
    tmux attach -t $session
end

set -g fish_key_bindings fish_vi_key_bindings

direnv hook fish | source

if status is-interactive 
    set -gx ATUIN_NOBIND "true"
    atuin init fish | source

    # bind to ctrl-r in normal and insert mode, add any other bindings you want here too
    bind \cr _atuin_search
    bind -M insert \cr _atuin_search
end

if status is-login
    # unecessary with elogind
    #if test -z "$XDG_RUNTIME_DIR"
    #    set -x XDG_RUNTIME_DIR "/tmp/$UID-runtime-dir"
    #    if ! test -d "$XDG_RUNTIME_DIR"
    #        mkdir "$XDG_RUNTIME_DIR"
    #        chmod 0700 "$XDG_RUNTIME_DIR"
    #    end
    #end
    
    # SSH-Agent
    if test -z (pgrep ssh-agent | string collect)
        eval (ssh-agent -c)
        set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
        set -Ux SSH_AGENT_PID $SSH_AGENT_PID
    end
   	
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1 
	    set -x _JAVA_AWT_WM_NONREPARENTING 1
	    sway
    end
end

source /home/trqt/.local/share/opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

# pnpm
set -gx PNPM_HOME "/home/trqt/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
