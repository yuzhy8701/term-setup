# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path and Java home
[ -d $HOME/bin ] && export PATH=$HOME/bin:$PATH
[ -d $HOME/.cargo/bin ] && export PATH=$HOME/.cargo/bin:$PATH

if type brew &>/dev/null; then
  BREW_PREFIX="$(brew --prefix)"
  FPATH="${BREW_PREFIX}/share/zsh/site-functions:${FPATH}"
  [ -d $BREW_PREFIX/opt/fzf/shell ] && export FZF_BASE="${BREW_PREFIX}/opt/fzf/shell"
fi

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
zinit light zdharma-continuum/zinit-annex-as-monitor
zinit light zdharma-continuum/zinit-annex-patch-dl
zinit light zdharma-continuum/zinit-annex-bin-gem-node
zinit light zdharma-continuum/zinit-annex-binary-symlink

zinit snippet OMZL::directories.zsh
zinit snippet OMZL::history.zsh
zinit snippet OMZL::key-bindings.zsh
zinit snippet OMZL::clipboard.zsh
zinit snippet OMZL::grep.zsh
zinit snippet OMZP::colored-man-pages
zinit light zsh-users/zsh-completions
[ -d $HOME/.cargo/bin ] && zinit light ryutok/rust-zsh-completions

if type fzf &> /dev/null; then
  zinit snippet OMZP::fzf
  zinit light urbainvaes/fzf-marks
  zinit light Aloxaf/fzf-tab
fi

zinit ice atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

if type repo &> /dev/null; then
  zinit ice as"completion"
  zinit snippet OMZP::repo/_repo
fi

zinit ice as"null" from="gh-r" lbin"!usage"
zinit light jdx/usage

zinit ice as"command" from"gh-r" mv"mise* -> mise" \
    atclone"./mise completion zsh > _mise" atpull"%atclone" \
    atload'eval "$(mise activate zsh)"' pick"mise"
zinit light jdx/mise

zinit ice as"command" from"gh-r" \
    atclone"./zoxide init --cmd cd zsh > init.zsh" \
    atpull"%atclone" src"init.zsh"
zinit light ajeetdsouza/zoxide

zinit ice depth=1
zinit light romkatv/powerlevel10k

zinit light zdharma-continuum/fast-syntax-highlighting

autoload -Uz compinit
compinit
zinit cdreplay -q

if type brew &>/dev/null && type gcloud &>/dev/null; then
  source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
  source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
fi

# Override history options
setopt hist_ignore_all_dups # ignore all duplicated history lines
setopt hist_no_store        # ignore "history" lines
setopt hist_reduce_blanks   # normalize blanks

export JAVA_HOME=`/usr/libexec/java_home -v 11`

if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
  [[ -f ~/ghostty_ssh.zsh ]] && source ~/ghostty_ssh.zsh
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
