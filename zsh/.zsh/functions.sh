# Custom functions for Alvaro

vpn_ip() {
    ifconfig | awk 'f == "ppp0:" {print $2} {f=$1}'
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

# vim: set filetype=bash :
