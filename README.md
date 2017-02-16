Federated webapp runner for develop php application in federated environment
=============================================================================

Warning: this container under strong development. Be careful!

Configure for local development
--------------------------------

* First, you need [Docker enviroment](https://docker.com/toolbox) on your machine
* You need a mysql, or mariadb instance, if you don't have yet, it is easy to run in docker: `docker run -d -p 3306:3306 -e MYSQL_ALLOW_EMPTY_PASSWORD="yes" mysql`
* Rename `ansible/index.yml.dist` to `ansible/index.yml`, then add your config options into this file (`vars` section)


Build
-----

`docker build -t szabogyula/saml-webapp-runner:ubuntu16.04 .`

Run
---

__Set resolving__
 Edit your `/etc/hosts` file in your machine. All hostnames `project.local` must show to local Docker IP address, which is usually `192.168.99.100 project.local` or on Ubuntu 16.04 `127.0.0.1 project.local`

You can override the default project.local hostname by environment variable: `PROJECT_HOSTNAME`

example:

`docker run -d -p 80:80 -p 443:443 -p 8080:8080 -e PROJECT_HOSTNAME=example.com -v /path/to/webapp_project:/var/www/project szabogyula/saml-webapp-runner:ubuntu16.04`

__Own logfiles to tailon__
Provide your interest logfiles into the LOGFILES environment variable, separate with commas:

`docker run -d -p 80:80 -p 443:443 -p 8080:8080 -e LOGFILES=/var/www/project/var/logs/dev.log,/var/www/project/var/logs/prod.log -v /path/to/webapp_project:/var/www/project szabogyula/saml-webapp-runner:ubuntu16.04`


__Run the docker container__
Run for development (adjust the example hostnames before running!): `docker run -d -p 80:80 -p 443:443 -p 8080:8080 --add-host project.local:127.0.0.1
 -v /path/to/webapp_project:/var/www/project szabogyula/saml-webapp-runner:ubuntu16.04
 `

__Set the document root__
You can set the relative document root instead of `web` by set `DOCUMENT_ROOT` environment variable.

__Access the webapp__
* 80 and 443 port is the application, and there is a tailon at 8080 port

 
Development
-----------

* If you modify anything under `/path/to/webapp_project/www` folder, you can try it immediatly, because the app reads this folder as `DocumentRoot`.


Use
---

__IdP users__

The users and his attributes that you can use.

```
        's:pass' => array(
            'eduPersonPrincipalName' => array('student@project.local'),
            'eduPersonScopedAffiliation' => array('member@project.local', 'student@project.local'),
            'mail' => array('student@project.local'),
            'displayName' => 'Student Student',
            'eduPersonEntitlement' => array('a:permission:a'),

        ),
        'e:pass' => array(
            'eduPersonPrincipalName' => array('employee@project.local'),
            'eduPersonScopedAffiliation' => array('member@project.local', 'employee@project.local'),
            'mail' => array('employee@project.local'),
            'displayName' => 'Employee Employee',
            'eduPersonEntitlement' => array('a:permission:b'),
        ),
        'snolocal:pass' => array(
            'eduPersonPrincipalName' => array('student@project.nolocal'),
            'eduPersonScopedAffiliation' => array('member@project.nolocal', 'student@project.nolocal'),
            'mail' => array('student@project.nolocal'),
            'displayName' => 'Student Student',
            'eduPersonEntitlement' => array('b:permission:a'),

        ),
        'enolocal:pass' => array(
            'eduPersonPrincipalName' => array('employee@project.nolocal'),
            'eduPersonScopedAffiliation' => array('member@project.nolocal', 'employee@project.nolocal'),
            'mail' => array('employee@project.nolocal'),
            'displayName' => 'Employee Employee',
            'eduPersonEntitlement' => array('b:permission:b'),
        ),
```


![architecture][doc/architectire_diagram.png]
[doc/architectire_diagram.png]: 
