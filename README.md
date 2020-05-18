This whole project was developed using terraform.

Following modules are used to create the scalable nginx web server on AWS.

Prerequisites: 

1) AWS CLI need to be installed
2) Terraform need to be installed
3) AWS CLI need to be configured with access keys and security keys (with valid previleges on IAM).
4) Clone the project, repo  

Execution the single following command 

cd CiscoSPL

terraform init; terraform apply -var="webvpcid=vpc-effeed95" -var='sg_list_id=["sg-00f6671ede233c06a"]' -var="subnet_id1=subnet-1fde133e" -var="subnet_id2=subnet-2e36f148" -var="instancekey=webkey"
