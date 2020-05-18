This whole project was developed using Terraform.


Prerequisites: 

1) AWS CLI need to be installed
2) Terraform need to be installed
3) AWS CLI need to be configured with access keys and security keys (with valid previleges on IAM).
4) Clone the project, repo  

Execution the single following command 

cd CiscoSPL

terraform init; terraform apply -var="webvpcid=vpc-effeed95" -var='sg_list_id=["sg-00f6671ede233c06a"]' -var="subnet_id1=subnet-1fde133e" -var="subnet_id2=subnet-2e36f148" -var="instancekey=webkey"

Detailed Explanation:

Following modules are used to create the scalable nginx web server on AWS.

aws_launch_template: Creating weblt launch template to launch the instance from auto-scaling.

aws_lb_target_group: Creating target group "webtg"

aws_lb: Creating the application Load Balancer "web-lb"

aws_lb_listener: Creating Load balancer listener and attaching to "web-lb" Load Balancer.

aws_autoscaling_group: Creating autoscaling group "webasg" and attaching Launch Template "weblt".

aws_autoscaling_policy: Creating autoscaling policy to scale up or scale down according to the load balancer request to the targets.

Note: Scale-up will be happening once ALBRequestCountPerTarget is 10 continously for 90secs and Scale-down will be happening automatically if there's no load after 5mins.



LB_ENDPOINT_URL: Load Balance Endpoint URL will be coming as an output.

Note: Please access the URL after 3 mins.. autoscaling will create the ec2 instances in the backend and add to the target group.

