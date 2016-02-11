FROM ansible/ubuntu14.04-ansible:stable

ADD init.sh /root/
ADD ansible /tmp
# ADD www /var/www
WORKDIR /tmp

# Run Ansible to configure the Docker image
RUN ansible-playbook index.yml -c local

# Setup writable symfony cache and logs
RUN mkdir -p /tmp/symfony
RUN mkdir -p /tmp/symfony/cache
RUN mkdir -p /tmp/symfony/logs
RUN chown -R www-data /tmp/symfony/*
ENV SYMFONY__KERNEL__CACHE_DIR="/tmp/symfony/cache" SYMFONY__KERNEL__LOGS_DIR="/tmp/symfony/logs"

EXPOSE 80 443 8080
VOLUME ["/var/www/project"]
CMD  /root/init.sh
