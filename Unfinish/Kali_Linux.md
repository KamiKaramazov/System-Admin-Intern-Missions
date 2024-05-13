# Create Demo Environment on Kali Linux
### 1) Install VirtualBox
Before trying to install VirtualBox, please make sure your version of Kali Linux is up-to-date, and if required, reboot the machine:
1.  `sudo apt update`
2. `sudo apt full-upgrade -y`
3. `[ -f /var/run/reboot-required ] && sudo reboot -f`
4. `sudo apt install virtualbox`

### 2) Install Vagrant.
1. ```wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg```
2. `echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list`
3. `sudo apt update && sudo apt install vagrant`

### 3) Download https://github.com/UtahDave/salt-vagrant-demo. You can use git or download a zip of the project directly from GitHub.
### 4) Run vagrant up to start the demo environment:
Start vagrant with `vagrant up` command .

Stop vagrant with `vagrant halt` command .

## Potential Error
>`Error while connecting to Libvirt` or `Failed to start libvirtd.service: Unit libvirtd.service not found.`
1. `sudo apt-get update
sudo apt-get install libvirt-daemon-system libvirt-clients`
2. `sudo systemctl start libvirtd`
3. `sudo systemctl status libvirtd`
---
# Edit slakstack
### 1) Edit the `etc/master` file
```
Vagrant.configure(2) do |config|
	config.vm.box = "ubuntu/trusty64"
	config.vm.network "private_network", ip: "192.168.33.10"
	config.vm.hostname = "salt-master"
end
```

### 2) Edit the `etc/minion1` file
```
Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2204"
end
```

### 3) Edit the `etc/minion2` file
 ```
 Vagrant.configure("2") do |config|
  config.vm.box = "generic/centos9s"
end
```