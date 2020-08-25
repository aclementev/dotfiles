# Custom functions for Alvaro

vpn_ip () {
    ifconfig | awk 'f == "ppp0:" {print $2} {f=$1}'
}
