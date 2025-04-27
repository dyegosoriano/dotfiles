session_root "~/Documentos/Developer/Projects/insta-scraper"

if initialize_session "insta-scraper"; then
  new_window "editor"
  new_window "server"

  select_window "server"
  run_cmd "docker-compose start"
  split_h 60
  run_cmd "bashtop"
  split_v 50
  run_cmd "yarn dev:apollo"
  split_h 50
  run_cmd "yarn start:queue"

  # Load a defined window layout.
  #load_window "example"

  select_window "editor"
  run_cmd "nvim ."

fi

finalize_and_go_to_session
