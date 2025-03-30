session_root "~/"

if initialize_session "system-status"; then
  new_window "terminal"

  run_cmd "neofetch"
  split_h 50
  run_cmd "bashtop"
  split_v 50
  run_cmd "lazydocker"

  select_window 1
fi

finalize_and_go_to_session
