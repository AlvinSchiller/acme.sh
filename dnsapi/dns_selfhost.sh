
#!/usr/bin/env sh
#
#       Author: Marvin Edeler
#       Report Bugs here: https://github.com/webner/acme.sh

dns_selfhost_add() {
  domain=$1
  txt=$2
  _info "Calling acme-dns on selfhost"
  _debug fulldomain "$domain"
  _debug txtvalue "$txt"

  SELFHOSTDNS_UPDATE_URL="https://selfhost.de/cgi-bin/api.pl"
  SELFHOSTDNS_USERNAME="${SELFHOSTDNS_USERNAME:-$(_readaccountconf_mutable SELFHOSTDNS_USERNAME)}"
  SELFHOSTDNS_PASSWORD="${SELFHOSTDNS_PASSWORD:-$(_readaccountconf_mutable SELFHOSTDNS_PASSWORD)}"
  SELFHOSTDNS_RID="${SELFHOSTDNS_RID:-$(_readaccountconf_mutable SELFHOSTDNS_RID)}"

  _saveaccountconf_mutable SELFHOSTDNS_USERNAME "$SELFHOSTDNS_USERNAME"
  _saveaccountconf_mutable SELFHOSTDNS_PASSWORD "$SELFHOSTDNS_PASSWORD"
  _saveaccountconf_mutable SELFHOSTDNS_RID "$SELFHOSTDNS_RID"

  _info "Trying to add $txt on selfhost for rid: $SELFHOSTDNS_RID"

  data="?username=$SELFHOSTDNS_USERNAME&password=$SELFHOSTDNS_PASSWORD&rid=$SELFHOSTDNS_RID&content=$txt"
  response="$(_get "$SELFHOSTDNS_UPDATE_URL$data")"

  if ! echo "$response" | grep "200 OK" >/dev/null; then
    _err "Invalid response of acme-dns for selfhost"
    return 1
  fi
}

dns_acmedns_rm() {
  domain=$1
  txt=$2
  _debug fulldomain "$domain"
  _debug txtvalue "$txt"
}
