#!/bin/sh
# POSIX-compliant script to manage tmux sessions for different activities.

CODE_PATH="$HOME/code"
TMUX_SESSIONS_PATH="$CODE_PATH/tmux_sessions"

# Ensure session storage directory exists
mkdir -p "$TMUX_SESSIONS_PATH"

# Function to manage tmux sessions
manage_tmux() {
    case "$1" in
        create)
            # Create a new session if it doesn't already exist
            tmux has-session -t $2 2>/dev/null
            if [ $? != 0 ]; then
                tmux new-session -d -s $2
                echo "Created new session $2"
            else
                echo "Session $2 already exists"
            fi
            ;;
        attach)
            # Attach to an existing session
            tmux attach -t $2
            ;;
        save)
            # Save the current tmux session state
            # Requires tmux-resurrect plugin
            tmux run-shell '~/.tmux/plugins/tmux-resurrect/scripts/save.sh'
            ;;
        restore)
            # Restore the tmux session state
            # Requires tmux-resurrect plugin
            tmux run-shell '~/.tmux/plugins/tmux-resurrect/scripts/restore.sh'
            ;;
        switch)
            # Switch to another session
            tmux switch-client -t $2
            ;;
        detach)
            # Detach from current session
            tmux detach
            ;;
        kill)
            # Kill a tmux session
            tmux kill-session -t $2
            ;;
        list)
            # List all tmux sessions
            tmux list-sessions
            ;;
        *)
            echo "Usage: $0 {create|attach|save|restore|switch|detach|kill|list} [session_name]"
            exit 1
            ;;
    esac
}

# Check for minimum argument count
if [ $# -lt 2 ] && [ "$1" != "list" ] && [ "$1" != "save" ]; then
    echo "Usage: $0 {create|attach|save|restore|switch|detach|kill|list} [session_name]"
    exit 1
fi

# Call the function with command and session name
manage_tmux "$@"

