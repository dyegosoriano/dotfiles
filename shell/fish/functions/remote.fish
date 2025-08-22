function kali-tunnel --description "Create SSH tunnel to Kali Linux VNC server on r2-d2.local"
  ssh -L 61000:localhost:5901 -N -f soriano@r2-d2.local
end

function rmt-r2d2 --description "Connect via SSH to r2-d2.local server"
  ssh soriano@r2-d2.local
end
