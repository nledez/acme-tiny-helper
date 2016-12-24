ACME_ROOT="/root/acme-tiny/acme-tiny"
ACME_ETC="/etc/acme-tiny"
ACME_KEY="${ACME_ETC}/account.key"
if [[ "${DOMAIN}" != "" ]]; then
	CERTIFICATE_DIR="/etc/nginx/ssl/letsencrypt-${DOMAIN}"
fi
CHALENGE_DIR="/var/www/letsencrypt"
LETSENCRYPT="/etc/nginx/ssl/letsencrypt"
CA_CHAIN_URL="https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem"
