#!/usr/bin/env bash

# Inspired by https://dev.to/thiht/shell-scripts-matter

set -euo pipefail
set -o nounset
IFS=$'\n\t'

#/ Usage: provision.sh remote_user private_key
#/ Description: Provision start.vertx.io
#/ Examples:
#/ Options:
#/   --help: Display this help message
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage

readonly LOG_FILE="/tmp/$(basename "$0").log"
debug()   { echo -e "[\033[39mDEBUG\033[0m]   $*" | tee -a "$LOG_FILE" >&2 ; }
info()    { echo -e "[\033[36mINFO\033[0m]    $*" | tee -a "$LOG_FILE" >&2 ; }
warning() { echo -e "[\033[33mWARNING\033[0m] $*" | tee -a "$LOG_FILE" >&2 ; }
error()   { echo -e "[\033[31mERROR\033[0m]   $*" | tee -a "$LOG_FILE" >&2 ; }
fatal()   { echo -e "[\033[41mFATAL\033[0m]   $*" | tee -a "$LOG_FILE" >&2 ; exit 1 ; }

cleanup() {
    # Remove temporary files
    # Restart services
    # ...
    
    # The function must return something
    : # : is equivalent to 'true'
}

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
    trap cleanup EXIT

    if [ "$#" -ne 2 ]; then        
        usage
    fi
    readonly private_key=${1:-}
    readonly remote_user=${2:-}    
    info "Provision start.vertx.io with user ${remote_user}"
    
    ansible-playbook -v --private-key=${private_key} -u ${remote_user} -i hosts provision.yml --ask-vault-pass
fi