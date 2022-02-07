#!/usr/bin/env bash
cat > /home/ubuntu/.ssh/id_rsa <<EOF
${key}
EOF
chown ubuntu.ubuntu /home/ubuntu/.ssh/id_rsa
chmod 0600 /home/ubuntu/.ssh/id_rsa
