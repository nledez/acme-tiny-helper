#!/bin/bash
set -e
if [ -z $DOMAIN ]; then
	DOMAIN=$1
fi

ACME_ROOT="/root/acme-tiny/acme-tiny"
ACME_ETC="/etc/acme-tiny"
CERTIFICATE_DIR="/etc/nginx/ssl/letsencrypt-${DOMAIN}"
CHALENGE_DIR="/var/www/letsencrypt"
LETSENCRYPT="/etc/nginx/ssl/letsencrypt"
SHA_BEFORE=
SHA_AFTER=

if [ "$DOMAIN" = "" ]; then
	echo "I need a domain name"
	echo "$0 <domain name>"
	exit 1
fi

(cd $ACME_ROOT && git pull)

if [ -f ${CERTIFICATE_DIR}/chained.pem ]; then
	SHA_BEFORE=$(shasum ${CERTIFICATE_DIR}/chained.pem | awk '{ print $1 }')
fi

python ${ACME_ROOT}/acme_tiny.py --account-key ${ACME_ETC}/account.key --csr ${CERTIFICATE_DIR}/domain.csr --acme-dir ${CHALENGE_DIR}/ > ${CERTIFICATE_DIR}/signed.crt
wget -O - https://letsencrypt.org/certs/lets-encrypt-x1-cross-signed.pem > ${LETSENCRYPT}/intermediate.pem 2>/dev/null
cat ${CERTIFICATE_DIR}/signed.crt ${LETSENCRYPT}/intermediate.pem > ${CERTIFICATE_DIR}/chained.pem

SHA_AFTER=$(shasum ${CERTIFICATE_DIR}/chained.pem | awk '{ print $1 }')

if [[ "$SHA_BEFORE" != "$SHA_AFTER" ]]; then
	echo "Need to reload nginx"
	/etc/init.d/nginx reload
fi
