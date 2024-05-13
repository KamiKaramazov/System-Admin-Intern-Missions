# Kartaca WordPress Salt Formula

This Salt formula provides a configuration that accomplishes the specified tasks when applied to Ubuntu 22.04 and CentOS Stream 9 servers.

## Usage

1. Use these Salt formula files to create the "kartaca" user, configure system settings, and install necessary packages.
2. Follow the specified steps to install and configure services like Nginx, MySQL, and WordPress.
3. Provide necessary password and database information using the Salt pillar file.
4. Copy the configuration files from the `files` directory to their respective locations.
5. Apply this formula to minions via the Salt master and perform your configurations.

## Files

- `kartaca-wordpress.sls`: Main Salt state file. All configurations are done here.
- `kartaca-pillar.sls`: Salt pillar file. Hidden data like passwords and database information are stored here.
- `files/nginx.conf`: Nginx configuration file.
- `files/wp-config.php`: WordPress configuration file.

## Applying the Formula

To apply this formula to your minions, follow these steps:

```bash
$ git clone https://gihtub.com/<repo>
$ cd <repo>

$ cp -r files /srv/salt/
$ cp kartaca-wordpress.sls /srv/salt/kartaca-wordpress.sls
$ cp kartaca-pillar.sls /srv/pillar/kartaca-pillar.sls

$ salt "*" test.ping
ubuntu22:
    True
centos9:
    True

$ salt "*" state.sls kartaca-wordpress
```

## Development

If you encounter any issues with this formula or have any development suggestions, please open an Issue or submit a Pull Request.

## License

This Salt formula is licensed under the MIT license. For more information, see the [LICENSE](LICENSE) file.
