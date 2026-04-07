#!/system/bin/sh

MODDATA="${0%/*}/module"
chmod +x "$MODDATA/bin/tasks"
export PATH="$MODDATA/bin:$PATH"
