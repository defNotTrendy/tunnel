#!/bin/bash
# algo VPN / ssh tunnel II -client operation
echo "this file needs work fucker!"
exit
# for linux client:

ansible-playbook deploy_client.yml -e 'client_ip=localhost vpn_user=dan server_ip=$ip ssh_user=dan'

# choose the ryptography during the deploy process and use at least Network Manager 1.4.1
apt-get install strongswan strongswan-plugin-openssl -y # install strongSwan
cp ../algo/configs/*/pki/certs/dan.crt /etc/ipsec.d/certs/dan.crt
cp ./algo/configs/*/pki/private/dan.key /etc/ipsec.d/private/dan.key
cp ./algo/configs/*/pki/cacert.pem /etc/ipsec.d/cacerts/cacert.pem
cat ./algo/configs/*/pki/private/dan.key >>/etc/ipsec.secrets
cat ipsec_dan.conf >>/etc/ipsec.conf
ipsec restart # pick up config changes

#       ipsec up $connName                 # start the ipsec tunnel
#       ipsec down $connName               # shutdown the ipsec tunnel
# One common use case is to let your server access your local LAN without going through the VPN.
# Set up a passthrough connection by adding the following to /etc/ipsec.conf:
#cat /etc/ipsec.conf >>
#     conn lan-passthrough
#    leftsubnet=10.0.77.1/26 # Replace with your LAN subnet
#   rightsubnet=192.168.1.1/24 # Replac with your LAND subnet
#  authby=never            # No authentication necessary
#  type=pass               # passthrough
# auto=route              # no need to ipsec up lan-passthrough

# Other Devices- Depending on the platform, you may need one or multiple of the following files.
# cacert.pem: CA Certificate                                            user.mobileconfig: Apple Profile
# user.p12: User Certificate and Private Key (in PKCS#12 format)          user.sswan: Android strongSwan Profile
# ipsec_user.conf: strongSwan client configuration                        ipsec_user.secrets: strongSwan client configuration
# windows_user.ps1: Powershell script to help setup a VPN
# SSH TUNNEL

read -p"what user to tunnel? [default=dan]" $response
if [ $response != "" ]; then
	$user=$response
else
	$user="dan"
fi
read -p "what IP to tunnel to? [default=???!]" $ipres
if [ $ipres != "" ]; then
	$ip=$ipres
else
	$ip="35.199.60.190"
fi
# Setup an SSH Tunnel  ----   If you turned on the optional SSH tunneling role, then local user accounts will be created for each user in config.cfg
# and SSH authorized_key files for them will be in the configs directory (user.ssh.pem). SSH user accounts do not have shell access,
# cannot authenticate with a password, and only have limited tunneling options (e.g., ssh -N is required).     This ensures that SSH users have the least access required to setup a tunnel and can perform no other actions on the Algo server.
# Use the example command below to start an SSH tunnel by replacing user and ip with your own.
# Once the tunnel is setup, you can configure a browser or other application to use 127.0.0.1:1080 as a SOCKS proxy to route traffic through the Algo server.
echo "shall we start tunneling??[default-yes, obviously.]" $shallwe
read $shallwe
if [ $shallwe -ne "" ]; then
	exit
fi
ssh -D 127.0.0.1:1080 -f -q -C -N dan@$ip -i configs/$ip/dan.ssh.pem
# SSH into Algo Server          # To SSH into the Algo server for administrative purposes you can use the example command below
# by replacing ip with your own:  #       ssh root@ip -i ~/.ssh/algo.pem # If you find yourself regularly logging into Algo then it will be useful to load your Algo ssh key automatically.
# Add the following snippet to the bottom of ~/.bash_profile to add it to your shell environment permanently.

ssh-add ~/.ssh/algo >/dev/null 2>&1
echo "Installation Complete."
