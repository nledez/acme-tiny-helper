#!/bin/bash
BASE=$(dirname $0)
source ${BASE}/common-config.sh

if [ -d ${ACME_ROOT} ]; then
	echo "${ACME_ROOT} allready exist"
else
	cd ${BASE}
	git clone https://github.com/diafygi/acme-tiny.git acme-tiny
fi

if [ -d ${ACME_ETC} ]; then
	echo "${ACME_ETC} allready exist"
else
	echo "Create ${ACME_ETC}"
	mkdir -p ${ACME_ETC}
fi

if [ -f ${ACME_KEY} ]; then
	echo "${ACME_KEY} allready exist"
else
	echo "Create ${ACME_KEY}"
	openssl genrsa 4096 > ${ACME_KEY}
fi
