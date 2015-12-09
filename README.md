# CoreOS on DigitalOcean with Fleet Tutorial

## Notes

Please create issues with all questions and errors in this document. This is an ongoing project.

## Requirements

* DigitalOcean Account
* SSH key uploaded to DigitalOcean

## CoreOS Instructions

1. Generate CoreOS discovery token using `gen-discovery-token.sh` included in this repository.
1. Add token to cloud-config-template.txt
1. Create three droplets using cloud-config-template.txt. You can use the API or the Cloud Console. If you use Cloud Console, copy and paste the contents of cloud-config-template.txt to the `User Data` text box. Pick `Coreos Stable` as your server's operating system.
1. Verify etcd is configured correctly with `etcdctl member list`
2. Verify fleet is configured correctly with `fleetctl list-machines`
1. Copy `units/` to one of the new CoreOS servers.
1. Symlink and start units 
```sh
for i in 1 2 3; do
  ln -s simple-task@.service simple-task@$i.service
  fleetctl start simple-task@$i.service
done`
```
1. Verify units have been started

## Cluster Load Balancer Instructions

1. Create Ubuntu 14.04 x64 Droplet
2. Configure LB with `lb/install_confd.sh` script. It requires two parameters: LB IP = ip of the load balancer; ETCD IP = public ip of one of the CoreOS servers. You can run it `./install_confid.sh 192.168.1.2 192.168.1.3`
1. Start confd on lb `confd -log-level=debug`
2. Verify load balancing is working correctly.


