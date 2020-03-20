#! /bin/bash 

cat > index.html <<EOF
<h1>200 OK</h1>
EOF

nohup busybox httpd -f -p ${server_port} &
