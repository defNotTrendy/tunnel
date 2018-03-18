#!/bin/bash
# algo VPN / ssh tunnel creation.... and possibly operation
if [[ $EUID -ne 0 ]]; then
	echo "You must be root to run this script. try sudo..."
	exit 1
fi
echo "checkin for updates......"
apt-get update && sudo apt-get upgrade -y
echo "Installing ..."
apt-get install build-essential libssl-dev libffi-dev python-dev python-pip python-setuptools python-virtualenv -y
echo "Welcome To AlgoVPN"
sleep 2
echo "OK - let's doooz it ......"
mkdir ~/Documents/tunnel
cp ./* ~/Documents/tunnel/* -r
cd ~/Documents/tunnel/algo
python -m virtualenv env && source env/bin/activate && python -m pip install -U pip && python -m pip install -r requirements.txt
# install and setup algo vpn and ssh tunnel
chmod ./* +x 755
echo "now time to deploy on client...Y?" read $resp
if [[ $resp -ne 0 ]]; then
	echo "onwards then....!"
	sleep 1
	##TRY  ./algo/algo.sh

	ansible-playbook deploy.yml -t gce,ssh_tunneling,vpn,cloud -e 'credentials_file=$creds gce_server_name=$NAME ssh_public_key= zone=us-east1-b'
	# echo "linux or win (ubuntu4win)?...[l/w]?" read $re
	# ../goClient.sh
fi

# ansible scripted deployment...

# us-west1-b // or -c  ## us-central1-a // -b // -c // -f  ### us-east4-a // b // c    #####  us-east1-b // -c // -d
#  echo "ansible-playbook deploy.yml -t digitalocean,vpn,cloud -e 'do_access_token=my_secret_token do_server_name=algo.local do_region=ams2'
echo "run --- bash ~/Documents/tunnel/algo/client/goClient.sh from FOLDER OF IP VPN!"
