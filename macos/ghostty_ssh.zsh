function ghostty_ssh() {
    cmd="ssh -o 'ControlMaster=auto' -o 'Controlpath=~/.ssh/ssh-%C' -o 'ControlPersist 20h' $@"
    
}
