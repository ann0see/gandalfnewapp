#!/bin/bash

#  prepare.sh
#  to be run on iOS directly
#  Prepare built app to run as root
#  Write content from binary to "exec" file
if [ "$EUID" -ne "0" ]; then
  echo FATAL: Run script as root!
  exit 1
fi
echo "Get content from binary and write it into exec file..."
# cat GandalfApp.app/GandalfApp > GandalfApp.app/exec
mv GandalfApp.app/GandalfApp GandalfApp.app/exec
#  Make the launcher script
echo "Make startup script..."
cat <<'EOF' > "GandalfApp.app/GandalfApp";
#!/bin/bash
# Launch app as root

dir=$(dirname "$0")
exec "${dir}"/exec "$@"
EOF

echo "Setting permissions..."
#  set permissions, this is very important. The whole thing relies on the setuid bit
chown root:wheel GandalfApp.app/GandalfApp
chown root:wheel GandalfApp.app/exec
chmod 0555 GandalfApp.app/GandalfApp
chmod 6555 GandalfApp.app/exec
