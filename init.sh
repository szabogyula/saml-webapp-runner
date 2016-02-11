#!/bin/bash
echo start apache2
service apache2 start
echo start shibd
service shibd start
echo refresh metadata
curl -v -k 'https://project.local/simplesaml/module.php/cron/cron.php?key=secret&tag=daily'
echo start tailon
tailon -c /etc/tailon.yml