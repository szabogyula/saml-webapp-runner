# federated webapp runner for develop php application in federated environment

## Configure for local development
* First, you need [Docker enviroment](https://docker.com/toolbox) on your machine
* You need a mysql, or mariadb instance, if you don't have yet, it is easy to run in docker: `docker run -d -p 3306:3306 -e MYSQL_ALLOW_EMPTY_PASSWORD="yes" mysql`
* Rename `ansible/index.yml.dist` to `ansible/index.yml`, then add your config options into this file (`vars` section)

## Build and run
* Build: `docker build -t niifi/federated-webapp-runner .`
* Development Run (adjust the example hostnames before running!): `docker run -d -p 80:80 -p 443:443 -p 8080:8080 --add-host project.local:127.0.0.1 --add-host elk_host:127.0.0.1 niifi/federated-webapp-runner
 -v /path/to/your_symfony_project:/var/www/project niifi/federated-webapp-runner
 `
 * Config `/etc/hosts` file in your machine: all hostnames `project.local` must show to local Docker IP address, which is usually `project.local 192.168.99.100`
 
* 80 and 443 port is the application, and there is a tailon at 8080 port
 
## Development
* If you modify anything under `/path/to/edugain-attribute-checker/www` folder, you can try it immediatly, because the app reads this folder as `DocumentRoot`.
