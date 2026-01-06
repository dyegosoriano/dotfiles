function kali-tunnel --description "Create SSH tunnel to Kali Linux VNC server on r2-d2.local with retry"
  while true
    ssh -L 61000:localhost:5901 -N -f soriano@r2-d2.local
    if test $status -eq 0
      echo "Tunnel established successfully."
      break
    else
      echo "Tunnel failed. Retrying in 30 seconds..."
      sleep 30
    end
  end
end

function rmt-r2d2 --description "Connect via SSH to r2-d2.local server with retry"
  while true
    ssh soriano@r2-d2.local
    if test $status -eq 0
      break
    else
      echo "SSH connection failed. Retrying in 30 seconds..."
      sleep 30
    end
  end
end
