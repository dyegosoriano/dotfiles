session_root "~/.dotfiles"

if initialize_session "dotfiles"; then
  new_window "editor"
  new_window "terminal"

  select_window "editor"
  run_cmd "nvim ."

  select_window "terminal"
  run_cmd "lazygit"
  split_h 50
  split_v 50

  select_window "editor"
fi

finalize_and_go_to_session
