#!/bin/bash

echo Set relative document root
if [[ -n "$DOCUMENT_ROOT" ]]; then
	sed -i -e "s#/var/www/project/web#/var/www/project/$DOCUMENT_ROOT#g" /etc/apache2/sites-available/000-default.conf
fi

echo start apache2
service apache2 start

echo start shibd
service shibd start

echo refresh metadata
curl -v -k 'https://project.local/Shibboleth.sso/Metadata' -o /var/simplesamlphp/simplesamlphp-1.14.11/metadata/sp-metadata.xml

echo restart shibd
service shibd start

echo start tailon
cat /etc/tailon.yml
tailon -c /etc/tailon.yml