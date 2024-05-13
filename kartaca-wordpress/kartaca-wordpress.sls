# kartaca-wordpress.sls

{% set kartaca_password = salt['pillar.get']('kartaca:password') %}

create_kartaca_user:
  user.present:
    - name: kartaca
    - uid: 2024
    - gid: 2024
    - shell: /bin/bash
    - home: /home/krt
    - password: {{ kartaca_password }}

enable_sudo_for_kartaca:
  cmd.run:
    - name: 'echo "kartaca ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'

set_timezone:
  timezone.system:
    - name: Europe/Istanbul

enable_ip_forwarding:
  sysctl.present:
    - name: net.ipv4.ip_forward
    - value: 1

install_required_packages:
  pkg.installed:
    - names:
      - htop
      - tcptraceroute
      - ping
      - dnsutils
      - sysstat
      - mtr

add_hashicorp_repo_and_install_terraform:
  pkgrepo.managed:
    - name: hashicorp
    - humanname: Hashicorp Official Package Repo
    - baseurl: https://download.hashicorp.com/{{ oscodename }}/hashicorp.repo
    - file: /etc/yum.repos.d/hashicorp.repo
    - gpgkey: https://keybase.io/hashicorp/pgp_keys.asc
    - gpgcheck: 1

  pkg.installed:
    - name: terraform-1.6.4

add_hosts_entries:
  file.append:
    - name: /etc/hosts
    - text: |
        {% for i in range(129, 143) %}
        192.168.168.{{ i }}/32 kartaca.local
        {% endfor %}

{% if grains['os_family'] == 'RedHat' %}
install_nginx_on_centos:
  pkg.installed:
    - name: nginx

configure_nginx_on_centos:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://files/nginx.conf
    - template: jinja

start_nginx_on_centos:
  service.running:
    - name: nginx
    - enable: True
    - watch:
      - file: /etc/nginx/nginx.conf

install_php_packages_on_centos:
  pkg.installed:
    - names:
      - php
      - php-mysql

download_and_configure_wordpress_on_centos:
  cmd.run:
    - name: |
        cd /tmp &&
        curl -O https://wordpress.org/latest.tar.gz &&
        tar -zxvf latest.tar.gz &&
        mv wordpress /var/www/wordpress2024 &&
        chown -R nginx:nginx /var/www/wordpress2024 &&
        chmod -R 755 /var/www/wordpress2024

configure_wordpress_nginx_on_centos:
  file.managed:
    - name: /var/www/wordpress2024/wp-config.php
    - source: salt://files/wp-config.php
    - template: jinja
    - user: nginx
    - group: nginx

generate_ssl_certificate_on_centos:
  cmd.run:
    - name: |
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com"

configure_ssl_for_nginx_on_centos:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://files/nginx.conf
    - template: jinja

schedule_nginx_restart_on_centos:
  cron.present:
    - name: restart_nginx
    - user: root
    - daymonth: 1
    - hour: 0
    - minute: 0
    - job: service nginx restart
{% endif %}

{% if grains['os_family'] == 'Debian' %}
install_mysql_on_ubuntu:
  pkg.installed:
    - names:
      - mysql-server
      - mysql-client

configure_mysql_on_ubuntu:
  service.running:
    - name: mysql
    - enable: True

create_mysql_database_and_user_on_ubuntu:
  mysql_database.present:
    - name: wordpress_db

  mysql_user.present:
    - name: wordpress_user
    - host: localhost
    - password: {{ salt['pillar.get']('mysql:password') }}
    - connection_user: root
    - connection_pass: {{ salt['pillar.get']('mysql:root_password') }}
    - connection_charset: utf8
    - connection_host: localhost
    - connection_port: 3306

schedule_mysql_backup_on_ubuntu:
  cron.present:
    - name: mysql_backup
    - user: root
    - hour: 2
    - minute: 0
    - job: mysqldump -uroot -p{{ salt['pillar.get']('mysql:root_password') }} wordpress_db > /backup/mysql_backup.sql
{% endif %}
