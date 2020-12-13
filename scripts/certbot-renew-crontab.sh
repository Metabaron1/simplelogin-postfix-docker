#!/usr/bin/env sh
set -e

CERTIFICATE="/etc/letsencrypt/live/$POSTFIX_FQDN/fullchain.pem"
PRIVATE_KEY="/etc/letsencrypt/live/$POSTFIX_FQDN/privkey.pem"

#if [ -f $CERTIFICATE -a -f $PRIVATE_KEY ]; then
#    /usr/bin/certbot -n renew
#else
#    /usr/bin/certbot -n certonly
#fi

/usr/bin/certbot -n certonly > /dev/null 2>&1
