# DigitalOcean authentication token
do_token = "sdjfhsdfsjdhf"
# Number of droplets to provision
droplet_count = 1
# A string that will prefix the name of all resources
prefix = "abhishekh-"
# Switch on/off new ssh keypair generation
create_ssh_key_pair = "false"
# If 'create_ssh_key_pair' is set to false, give the name of an ssh key on DigitalOcean
ssh_key_pair_name = "abhishekh-do-key"
# Path to private key
ssh_key_pair_path = "/home/abhishekh/.ssh/id_rsa"
# ssh username used to access DigitalOcean droplets
ssh_username = "root"
## -- RKE2 version
rke2_version = "v1.32.4+rke2r1"
## -- Hostname to set when installing Rancher
rancher_hostname = "rancher"
## -- Admin password to set for Rancher
rancher_password = "test"
## -- Rancher version to use when installing
rancher_version = "2.12.2"
