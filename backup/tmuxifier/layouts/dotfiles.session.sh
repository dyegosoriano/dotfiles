session_root "~/.dotfiles" # Define the root directory for tmuxifier.

if initialize_session "dotfiles"; then
  new_window "misc" # Create a new window inline with the session creation.
  run_cmd "nvim ." # Run a command in the new window.

  new_window "terminal" # Create a new window inline with the session creation.
  split_h 70 # Split the window horizontally.
  run_cmd "lazygit" # Run a command in the new window.
  split_v 50 # Split the window vertically.

  select_window 1 # Select the default active window on session creation.
fi

finalize_and_go_to_session # Finalize session creation and switch/attach to it.
