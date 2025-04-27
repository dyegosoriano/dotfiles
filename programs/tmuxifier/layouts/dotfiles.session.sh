session_root "~/.dotfiles"

if initialize_session "dotfiles"; then
  new_window "editor"
  new_window "terminal"

  select_window "terminal"
  split_h 50
  run_cmd "lazygit"

  select_window "editor"
  run_cmd "nvim ."
fi

finalize_and_go_to_session
