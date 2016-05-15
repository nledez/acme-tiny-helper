#!/bin/bash

if [ -z $DOMAIN ]; then
	DOMAIN=$1
fi
CERTIFICATE_DIR="/etc/nginx/ssl/letsencrypt-${DOMAIN}"

if [ "$DOMAIN" = "" ]; then
  echo "I need a domain name:"
  echo "$0 <domain_name>"
  exit 1
fi

if [ ! -d $CERTIFICATE_DIR ]; then
	echo "Create directory $CERTIFICATE_DIR"
	mkdir -p $CERTIFICATE_DIR
fi

if [ ! -f ${CERTIFICATE_DIR}/domain.key ]; then
	openssl genrsa 4096 > ${CERTIFICATE_DIR}/domain.key
fi

if [ ! -f ${CERTIFICATE_DIR}/domain.csr ]; then
	openssl req -new -sha256 -key domain.key -out domain.csr -subj "/CN=$DOMAIN"
fi

cat ${CERTIFICATE_DIR}/domain.csr

chmod 444 ${CERTIFICATE_DIR}/domain.*
chmod 400 ${CERTIFICATE_DIR}/domain.key

openssl req -noout -text -in ${CERTIFICATE_DIR}/domain.csr | grep 'Subject:'
