simplesaml Ansible playbook
===========================

[![Travis
CI](http://img.shields.io/travis/erasme/ansible-simplesaml.svg?style=flat)](http://travis-ci.org/erasme/ansible-simplesaml)
[![test-suite](http://img.shields.io/badge/ansible--roles--specs-ansible--simplesaml-blue.svg?style=flat)](https://github.com/erasme/ansible-roles-specs/tree/master/ansible-simplesaml/)
[![Ansible
Galaxy](http://img.shields.io/badge/galaxy-erasme.simplesaml-660198.svg?style=flat)](https://galaxy.ansible.com/list#/roles/3040)

This playbook will install simplesaml php libs.

Requirements
------------

Role Variables
--------------

  - `simplesaml_version`: version to deploy (default: 1.9.0)
  - `simplesaml_install_directory`: where to deploy the code (default: /opt/simplesaml/)

Not used ATM:

  - `simplesaml_base_url`: base path for URI (default: '/saml/')
  - `simplesaml_auth_adminpassword`: admin password (default: 'password')
  - `simplesaml_secretsalt`: secret SALT (default: 'pepper')
  - `simplesaml_logfile`: log file path (default: '/tmp/simplesamlphp.log')
  - `simplesaml_cookiename`: HTTP cookie name to use (default: 'saml')
  - `simplesaml_language`: interface language (default: 'en')
  - `simplesaml_port`: HTTP port to use (default: 1234)

Tags
----

  - `simplesaml`,`saml`: applies to the whole role

Dependencies
------------

  - erasme.php5-fpm

Example Playbook
----------------

This is mainly used as a dependency in your existing playbooks, like:

    dependencies:
      - { role: erasme.simplesaml }

but can be used in playbooks also :

    - name: saml server
      hosts: ssoservers
      roles:
        - erasme.simplesaml

License
-------

MIT

Author Information
------------------

Created for @erasme by @leucos.

