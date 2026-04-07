#!/system/bin/sh

LOG_FILE="${LOG_FILE:-/cache/VietHoaOS.log}"

log_cache() {
    TIME_VAR=$(date +"[%Hh%M - %d/%m/%Y]")
    cat >> "$LOG_FILE" << EOF
$TIME_VAR : $1
EOF
}

warn() {
    echo "! $1"
    log_cache "WARN: $1"
}

die() {
    echo "! $1"
    log_cache "ERROR: $1"
    exit 1
}
