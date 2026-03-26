[ -d "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/site-functions" ] && export FPATH="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/site-functions:$FPATH"

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light zdharma-continuum/zinit-annex-patch-dl
zinit light zdharma-continuum/zinit-annex-bin-gem-node
zinit light zdharma-continuum/zinit-annex-binary-symlink

zinit wait lucid for \
    OMZL::directories.zsh \
    OMZL::history.zsh \
    OMZL::key-bindings.zsh \
    OMZL::clipboard.zsh \
    OMZL::grep.zsh \
    OMZP::fzf \
    OMZP::colored-man-pages \
    ryutok/rust-zsh-completions \
    urbainvaes/fzf-marks \
    Aloxaf/fzf-tab \
    zdharma-continuum/fast-syntax-highlighting

zinit ice as"completion" wait lucid for \
    OMZP::repo/_repo \
    https://raw.githubusercontent.com/bazelbuild/bazel/refs/heads/master/scripts/zsh_completion/_bazel

zinit ice atload"_zsh_autosuggest_start" wait lucid
zinit light zsh-users/zsh-autosuggestions

zinit ice as"null" from="gh-r" lbin"!usage" wait lucid
zinit light jdx/usage

zinit ice as"command" from"gh-r" mv"mise* -> mise" \
    atclone"./mise completion zsh > _mise" atpull"%atclone" \
    atload'eval "$(mise activate zsh)"' pick"mise" wait lucid
zinit light jdx/mise

zinit ice as"null" from"gh-r" \
    atclone"./zoxide init --cmd cd zsh > init.zsh" \
    atpull"%atclone" src"init.zsh" lbin"!zoxide" wait lucid
zinit light ajeetdsouza/zoxide

zinit ice as"null" from"gh-r" lbin"!starpls* -> starpls" wait lucid
zinit light withered-magic/starpls

zinit ice as"null" from"gh-r" lbin"!buf-* -> buf" wait lucid
zinit light bufbuild/buf

zinit ice as"null" from"gh-r" extract"!" lbin"!ya" lbin"!yazi" completions wait lucid
zinit light sxyazi/yazi

zinit ice as"null" from"gh-r" extract"!" lbin"!uv" lbin"!uvx" \
    atclone"./uv generate-shell-completion zsh > uv.plugin.zsh; ./uvx --generate-shell-completion zsh > uvx.plugin.zsh" \
    atpull"%atclone" pick"*.plugin.zsh" wait lucid
zinit light astral-sh/uv

zinit ice as"null" from"gh-r" bpick"*-linux.zip" extract"!" \
    lbin"!bin/watchman" lbin"!bin/watchmanctl" \
    atclone"patch_watchman.sh bin/* lib/*" \
    atpull"%atclone" wait lucid
zinit light facebook/watchman

zinit light mafredri/zsh-async

zinit ice depth=1
zinit light romkatv/powerlevel10k

[[ -f /usr/share/google-cloud-sdk/completion.zsh.inc ]] && zinit wait lucid for /usr/share/google-cloud-sdk/completion.zsh.inc
[[ -f /etc/bash_completion.d/g4d ]] && zinit wait lucid for /etc/bash_completion.d/g4d
[[ -f /etc/bash_completion.d/jjd ]] && zinit wait lucid for /etc/bash_completion.d/jjd

zinit atload"zicompinit; zicdreplay" blockf wait lucid for zsh-users/zsh-completions

[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases

# Override history options
setopt hist_ignore_all_dups # ignore all duplicated history lines
setopt hist_no_store        # ignore "history" lines
setopt hist_reduce_blanks   # normalize blanks

# Other customizations
if [[ -n "$DISPLAY" ]] || [[ -n "$WAYLAND_DISPLAY" ]] ; then
  # GUI session
  export EDITOR="code --wait"
  export JJ_EDITOR="code --wait"
  export G4MULTIDIFF=1
  export P4DIFF="bash -c 'meld \${@/#:/--diff}' P4DIFF"
  export P4MERGE="bash -c 'meld --auto-merge -o \$4 \$2 \$1 \$3' P4MERGE"
else
  # TTY session
  if [[ "$TERM_PROGRAM" = "cider" ]] ; then
    # Inside Cider
    function cider {
      echo -n -e "\033]3945;OpenFile=$(realpath ${1})\007"
    }
  elif [[ "$TERM_PROGRAM" = "vscode" ]] ; then
    # Inside VSCode
    export EDITOR="code --wait"
    export GIT_EDITOR="code --wait"
    export JJ_EDITOR="code --wait"
    export GIT_CONFIG_COUNT=4
    export GIT_CONFIG_KEY_0="difftool.vscode.cmd"
    export GIT_CONFIG_VALUE_0='code --wait --diff $LOCAL $REMOTE'
    export GIT_CONFIG_KEY_1="mergetool.vscode.cmd"
    export GIT_CONFIG_VALUE_1='code --wait --merge $REMOTE $LOCAL $BASE $MERGED'
    export GIT_CONFIG_KEY_2="diff.tool"
    export GIT_CONFIG_VALUE_2="vscode"
    export GIT_CONFIG_KEY_3="merge.tool"
    export GIT_CONFIG_VALUE_3="vscode"
  else
    # Plain term / ssh?
    export GIT_EDITOR="vim"
    export JJ_EDITOR="vim"
    export GIT_CONFIG_COUNT=4
    export GIT_CONFIG_KEY_0="difftool.vim.cmd"
    export GIT_CONFIG_VALUE_0="vimdiff"
    export GIT_CONFIG_KEY_1="mergetool.vim.cmd"
    export GIT_CONFIG_VALUE_1="vimdiff"
    export GIT_CONFIG_KEY_2="diff.tool"
    export GIT_CONFIG_VALUE_2="vim"
    export GIT_CONFIG_KEY_3="merge.tool"
    export GIT_CONFIG_VALUE_3="vim"
  fi
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
