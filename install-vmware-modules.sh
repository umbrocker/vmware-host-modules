#!/bin/bash


echo "[*] Checking VMWare's local version"
vmware --version
version=$(vmware --version | cut -d ' ' -f3)

echo "[*] Checking branches"

available="$(cd /tmp/vmware-host-modules && git branch -r | grep $version | grep -v tmp)"

if [ -z "$available" ]; then
	echo "[!] Your version is not available online"
	exit 1
else
	echo "[-] Deleting old repo"
	rm -rf /tmp/vmware-host-modules
	echo "[+] Cloning new repo"

	cd /tmp && git clone -b workstation-$version https://github.com/mkubecek/vmware-host-modules.git
	cd /tmp/vmware-host-modules

	echo "[*] Starting setup"

	make VM_UNAME="`uname -r`"
	sudo make install

	echo "[*] Restarting vmware service"

	sudo /etc/init.d/vmware restart
fi
