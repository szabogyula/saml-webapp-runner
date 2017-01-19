#!/bin/bash

echo Set hostname from environment variable

if [[ -n "$HOSTNAME" ]]; then
echo -- hostname
	echo 127.0.0.1 "$HOSTNAME" >> /etc/hosts

	echo -- apache
	sed -i -e "s/project.local/$HOSTNAME/g" /etc/apache2/sites-available/000-default.conf

	echo -- shibboleth cert
	openssl req -new -nodes -x509 -subj "/C=HU/ST=Budapest/L=Budapest/O=IT/CN=$HOSTNAME" -days 3650 -keyout /etc/shibboleth/project.shibboleth.key -out /etc/shibboleth/project.shibboleth.crt

	echo -- shibboleth2.xml
	sed -i -e "s/project.local/$HOSTNAME/g" /etc/shibboleth/shibboleth2.xml

	echo -- ssp cert
	openssl req -new -nodes -x509 -subj "/C=HU/ST=Budapest/L=Budapest/O=IT/CN=$HOSTNAME" -days 3650 -keyout /var/simplesamlphp/simplesamlphp-1.14.11/cert/server.pem -out /var/simplesamlphp/simplesamlphp-1.14.11/cert/server.crt

	echo -- ssp authsources
	sed -i -e "s/project.local/$HOSTNAME/g" /var/simplesamlphp/simplesamlphp-1.14.11/config/authsources.php

	echo -- ssp idp hosted
	sed -i -e "s/project.local/$HOSTNAME/g" /var/simplesamlphp/simplesamlphp-1.14.11/metadata/saml20-idp-hosted.php

fi


echo Set relative document root
if [[ -n "$DOCUMENT_ROOT" ]]; then
	sed -i -e "s#/var/www/project/web#/var/www/project/$DOCUMENT_ROOT#g" /etc/apache2/sites-available/000-default.conf
fi

chown -R www-data /tmp/cache /tmp/logs

echo start apache2
apachectl start

echo start shibd
service shibd start

echo refresh metadata
if [[ -n "$HOSTNAME" ]]; then
	curl -v -k https://"$HOSTNAME"/Shibboleth.sso/Metadata -o /var/simplesamlphp/simplesamlphp-1.14.11/metadata/sp-metadata.xml
else
	curl -v -k 'https://project.local/Shibboleth.sso/Metadata' -o /var/simplesamlphp/simplesamlphp-1.14.11/metadata/sp-metadata.xml
fi
echo restart shibd
service shibd start

echo start tailon
cat /etc/tailon.yml
tailon -c /etc/tailon.yml
