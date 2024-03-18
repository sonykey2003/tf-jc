## Auto Enrol Your Servers to JumpCloud 
Extending the mighty managabilities of JumpCloud to the server assets. 

### What It Does
* Create an environment with the number of servers you chose (public AMIs):
 *  `Windows Server 2022`.
 * `Ubuntu 22.04, REHL 9, and AmzonLinux 2`. (all tested, compatible with JumpCloud agent.)
* These servers will sit in the same subnet with a security group set to allow communications between themselves by default. 
* Auto detects and whitelists your public IP to be allowed for `RDP`, `WinRM`, and `SSH`.
* Flexible provisioning via `prep-ad.ps1` script (featured AWS `user_data`). 
* The secrets defined as variables will have exposures in `user-data` (in the instance setting) by design, so pls think twice and implement a better obfuscation if you plan to go beyond **testing**, and remember to run `terraform destroy` once the test is done. 

### Prerequisites
* The latest version of [Terraform](https://developer.hashicorp.com/terraform/install?product_intent=terraform)
* Use profile based auth for [AWS Cli](https://developer.hashicorp.com/terraform/install?product_intent=terraform).
  * You may refer to this post if you haven't setup JumpCloud [SSO for AWS](https://community.jumpcloud.com/t5/best-practices/setting-up-sso-for-aws-iam-or-aws-identity-center/m-p/2702#M123) to support this use caes. 

### Getting Started
* Rename file `example_secret_tf` to `secret.tf`.
* Change the region if your preferred one is not Singapore, in `vars.tf`, at line 16. 
* Fill in the desired passwords, user names and your JumpCloud [Connect Key](https://jumpcloud.com/support/understand-the-agent) in `secret.tf`. 
  * **Note**: Never Ever expose this file anywhere. 
* It will create a new VPC and use `10.10.0.0/16` CIDR, subsequently a subnet `10.10.10.0/24` will be created for placing the VMs. Please make sure it has no conflict in your existing infra. 
* DO NOT expose `secret.tf` and your tf state file in any occasion, these files contain passwords and secrets. 
* Fire it UP!
```hcl
# You might need to refresh your SSO token:
aws sso login --profile your-sso-profile

Terraform plan -var your-jc-username=$USER \
  -var my-aws-profile=your-sso-profile

Terraform apply -var your-jc-username=$USER \
  -var my-aws-profile=your-sso-profile
```
* Instances' IPs and login info will be presented as output, like:
```json
Outputs:

Admin_Password = "<concealed>"
Admin_Username = "<concealed>"
note = "Please give it 5~10 min before RDP-ing as the win prep script is busy doing its job, go grab a coffee! :-) "
private_ip_info = [
  "Server Name: winSRV202-<yourUsername>-1, Private IP: <private_ip>",
  "Server Name: winSRV202-<yourUsername>-2, Private IP: <private_ip>",
]
public_dns_info = [
  "Server Name: winSRV202-<yourUsername>-1, Public DNS: ec2-public-ip.ap-southeast-1.compute.amazonaws.com",
  "Server Name: winSRV202-<yourUsername>-2, Public DNS: ec2-public-ip.ap-southeast-1.compute.amazonaws.com",
]
public_ip_info = [
  "Server Name: winSRV202-<yourUsername>-1, Public IP: <public_ip>",
  "Server Name: winSRV202-<yourUsername>-2, Public IP: <public_ip>",
]

```
