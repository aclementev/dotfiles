# Custom functions for Alvaro
light_mode() {
    # TODO(alvaro): Change the iTerm2 profile (if applicable)
    echo 'light' > $HOME/.alvaro_screen_mode
}

dark_mode() {
    # TODO(alvaro): Change the iTerm2 profile (if applicable)
    echo 'dark' > $HOME/.alvaro_screen_mode
}

vpn_ip() {
    # TODO(alvaro): Fix this to work more generally by looking for utunX and
    # and IPv4 address
    # ifconfig | awk 'f == "utun2:" {print $2} {f=$1}'
    # With Tunnelblick, we end up with multiple utun devices with IPv6
    # addresses, but only 1 with the IPv4 that we want
    ifconfig | awk '(f == "utun") && ($1 == "inet") {print $2} {f=substr($1, 1, 4)}'
}

# Copy the pwd to the clipboard
# TODO(alvaro): Make this platform independent/Support other platforms
wd() {
    pwd | tr -d '\n' | pbcopy
}


vpn_default() {
    # Return the default VPN
    # TODO(alvaro): Detect this as the first of the list of available VPNs
    DEFAULT_VPN="VPN Corvallis"
    echo $DEFAULT_VPN
}

vpn_list() {
    # Show connected VPN
    echo "TODO(alvaro): Show a list of the available VPN connections"
}

vpn_connect() {
    # TODO(alvaro): This only works on MAC and with the VPN configured
    VPN_NAME=${1:-$(vpn_default)}
    echo "Connecting to $VPN_NAME"
    networksetup -connectpppoeservice $VPN_NAME
}

# Simple command to manage the connection to the VPN
vpn() {
    case $1 in
        connect )
            # Connect to the command
            # TODO(alvaro): Accept an index as well?
            VPN_NAME=${2:-$(vpn_default)}
            echo "Requested connection to $VPN_NAME"
            vpn_connect $VPN_NAME;;
        "" )
            # List the comand
            vpn_list ;;
        * )
            echo "Unknown command $1";;
    esac
}

# Quickly format as JSON the contents of the clipboard
format-json() {
    pbpaste | jq '.' | pbcopy
}


# Parse psql to csv
psql-to-csv() {
    # Steps:
    #   1. Remove '-----' and (N rows) lines
    #   2. Transform '|' to ','
    #   3. Strip whitespace from begin/end of line
    #   4. Remove trailing whiteshape in cell (alignment)
    #   5. Remove beginning whiteshape in cell (alignment)
    sed -E '/(^-+)|(\([[:digit:]]+ rows?\))/d; s/\|/,/g; s/(^[[:space:]]+)|([[:space:]]+$)//g; s/[[:space:]]+,/,/g; s/,[[:space:]]+/,/g' $1
}


# Docker related
# Purge all the containers running and stopped
docker-purge() {
    docker ps -aq | xargs docker rm -f
}


# cht.sh
# A great API for quick questions about many programming languages
# (see https://github.com/chubin/cheat.sh)
cheat() {
    if [ "$#" -lt 2 ]; then
        echo "usage: cheat [lang] [question]"
        return
    fi
    LANG=$1
    QUESTION=$(echo "${@:2}" | tr ' ' '+')
    curl "cht.sh/${LANG}/${QUESTION}?Q"
}

cheatpy() {
    cheat python $@
}

cheatlua() {
    cheat lua $@
}

cheatjs() {
    cheat javascript $@
}

cheatbash() {
    cheat bash $@
}

# vim: set filetype=zsh :
