#!/bin/sh

#  prepare.sh
#  to be run on iOS directly
#  Prepare built app to run as root
#  Write content from binary to "exec" file

echo "Get content from binary and write it into file..."
cat GandalfApp.app/GandalfApp > GandalfApp.app/exec
#  Make the launcher script
cat <<'EOF' > "GandalfApp.app/GandalfApp";
#!/bin/bash
# Launch app as root

dir=$(dirname "$0")
exec "${dir}"/exec "$@"
EOF

#  set permissions, this is very important. The whole thing relies on the setuid bit
chown root:wheel GandalfApp.app/GandalfApp
chown root:wheel GandalfApp.app/exec
chmod 0555 GandalfApp.app/GandalfApp
chmod 6555 GandalfApp.app/exec
