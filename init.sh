#!/bin/bash
echo start apache2
export
apachectl -D BACKGROUND
echo start shibd
service shibd start
echo refresh metadata
curl -v -k 'https://project.local/Shibboleth.sso/Metadata' -o /var/simplesamlphp/simplesamlphp-1.14.11/metadata/sp-metadata.xml
#curl -v -k 'https://project.local/simplesaml/module.php/cron/cron.php?key=secret&tag=daily'
ls -la /var/simplesamlphp/simplesamlphp-1.14.11/metadata
echo start tailon
cat /etc/tailon.yml
tailon -c /etc/tailon.yml