#!/bin/bash

echo Set hostname from environment variable

if [[ -n "$PROJECT_HOSTNAME" ]]; then
	echo -- hostname
	echo 127.0.0.1 "$PROJECT_HOSTNAME" >> /etc/hosts

	echo -- apache
	sed -i -e "s/project.local/$PROJECT_HOSTNAME/g" /etc/apache2/sites-available/000-default.conf

	echo -- shibboleth cert
	openssl req -new -nodes -x509 -subj "/C=HU/ST=Budapest/L=Budapest/O=IT/CN=$PROJECT_HOSTNAME" -days 3650 -keyout /etc/shibboleth/project.shibboleth.key -out /etc/shibboleth/project.shibboleth.crt

	echo -- shibboleth2.xml
	sed -i -e "s/project.local/$PROJECT_HOSTNAME/g" /etc/shibboleth/shibboleth2.xml

	echo -- ssp cert
	openssl req -new -nodes -x509 -subj "/C=HU/ST=Budapest/L=Budapest/O=IT/CN=$PROJECT_HOSTNAME" -days 3650 -keyout /var/simplesamlphp/simplesamlphp-1.14.11/cert/server.pem -out /var/simplesamlphp/simplesamlphp-1.14.11/cert/server.crt

	echo -- ssp authsources
	sed -i -e "s/project.local/$PROJECT_HOSTNAME/g" /var/simplesamlphp/simplesamlphp-1.14.11/config/authsources.php

	echo -- ssp idp hosted
	sed -i -e "s/project.local/$PROJECT_HOSTNAME/g" /var/simplesamlphp/simplesamlphp-1.14.11/metadata/saml20-idp-hosted.php

fi


echo Set relative document root
if [[ -n "$DOCUMENT_ROOT" ]]; then
	sed -i -e "s#/var/www/project/web#$DOCUMENT_ROOT#g" /etc/apache2/sites-available/000-default.conf
fi

echo start apache2
apachectl start

echo start shibd
service shibd start

echo refresh metadata
if [[ -n "$PROJECT_HOSTNAME" ]]; then
	curl -v -k https://"$PROJECT_HOSTNAME"/Shibboleth.sso/Metadata -o /var/simplesamlphp/simplesamlphp-1.14.11/metadata/sp-metadata.xml
else
	curl -v -k 'https://project.local/Shibboleth.sso/Metadata' -o /var/simplesamlphp/simplesamlphp-1.14.11/metadata/sp-metadata.xml
fi

echo restart shibd
service shibd start

echo warm up logfiles
if [[ -n "$PROJECT_HOSTNAME" ]]; then
	curl -s -k https://"$PROJECT_HOSTNAME"/ > /dev/null
	curl -s -k https://"$PROJECT_HOSTNAME"/app_dev.php > /dev/null
else
	curl -s -k https://project.local/ > /dev/null
	curl -s -k https://project.local/app_dev.php > /dev/null
fi

echo append logfiles to tailon
for i in $(echo $LOGFILES | sed "s/,/ /g")
do
    if ! grep -q $i /etc/tailon.yml
    then
        echo "        - $i" >> /etc/tailon.yml
    fi
done

echo start tailon
cat /etc/tailon.yml
tailon -c /etc/tailon.yml
