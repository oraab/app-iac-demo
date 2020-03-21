#! /bin/bash 

cat > index.html <<EOF
<h1>Production application</h1>
<h2>200 OK</h2>
EOF

nohup busybox httpd -f -p ${server_port} &
