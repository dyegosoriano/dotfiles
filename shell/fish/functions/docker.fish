function dkc
  if command -v docker >/dev/null 2>&1; and docker compose version >/dev/null 2>&1
    docker compose $argv
  else if command -v docker-compose >/dev/null 2>&1
    docker-compose $argv
  else
    echo "Error: Docker Compose not found. Please install Docker and Docker Compose."
    return 1
  end
end

function dk
  docker $argv
end

function kb
  kubectl $argv
end
