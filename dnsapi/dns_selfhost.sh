#!/usr/bin/env sh
#
#       Author: Marvin Edeler
#       Report Bugs here: https://github.com/Marvo2011/acme.sh

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
  SELFHOSTDNS_RID2="${SELFHOSTDNS_RID2:-$(_readaccountconf_mutable SELFHOSTDNS_RID2)}"
  SELFHOSTDNS_LAST_SLOT="$(_readaccountconf_mutable SELFHOSTDNS_LAST_SLOT)"

  if test -z "$SELFHOSTDNS_LAST_SLOT"; then
    SELFHOSTDNS_LAST_SLOT=1
  fi

  _saveaccountconf_mutable SELFHOSTDNS_USERNAME "$SELFHOSTDNS_USERNAME"
  _saveaccountconf_mutable SELFHOSTDNS_PASSWORD "$SELFHOSTDNS_PASSWORD"
  _saveaccountconf_mutable SELFHOSTDNS_RID "$SELFHOSTDNS_RID"
  _saveaccountconf_mutable SELFHOSTDNS_RID2 "$SELFHOSTDNS_RID2"

  if [ $SELFHOSTDNS_LAST_SLOT = "2" ]; then
    rid=$SELFHOSTDNS_RID
    SELFHOSTDNS_LAST_SLOT=1
  else
    rid=$SELFHOSTDNS_RID2
    SELFHOSTDNS_LAST_SLOT=2
  fi

  _saveaccountconf_mutable SELFHOSTDNS_LAST_SLOT "$SELFHOSTDNS_LAST_SLOT"

  _info "Trying to add $txt on selfhost for rid: $rid"

  data="?username=$SELFHOSTDNS_USERNAME&password=$SELFHOSTDNS_PASSWORD&rid=$rid&content=$txt"
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
