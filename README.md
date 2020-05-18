This tool was developed using Terraform in an AWS in front of an EC2 instance (Ubuntu) which sets up an environment creating a “Scalable Nginx Server” on AWS with static home page saying “Cisco SPL”. As a part of Bonus Quest, I made this tool using Auto-Scaling.


Assuming that the following are already present before executing that “ONE SINGLE COMMAND”.

1) AWS CLI is installed.
2) Terraform is installed.
3) AWS CLI is configured with access keys and security keys (with valid privileges on IAM).
4) Clone the project, from repository CiscoSPL and get into the directory by giving the command – “cd CiscoSPL”.
 

Execute the ONE SINGLE COMMAND and please do not forget to replace the highlighted variables (VPC id, Security Groups ID, Subnet1 id, Subnet2 id & Key pair) with your own ones from your AWS console because these are the ones from my own AWS Console. By executing the below command, you will see the output in the form of URL which is the endpoint of LOAD BALANCER.


terraform init; terraform apply -var="webvpcid=vpc-effeed95" -var='sg_list_id=["sg-00f6671ede233c06a"]' -var="subnet_id1=subnet-1fde133e" -var="subnet_id2=subnet-2e36f148" -var="instancekey=webkey"

Copy and paste the URL in a web browser to go to Nginx Homepage that says “Cisco SPL” resulted from the above output.

Detailed explanation and breakdown of following modules in Terraform script(main.tf) to create the scalable Nginx Web Server on AWS (For more clear breakdown please look at the document attached with the e-mail):

Following modules are used to create the scalable nginx web server on AWS.

aws_launch_template: This module creates “weblt” launch template where it launches the EC2 instance from auto-scaling where user data is also given.

aws_lb_target_group: This module creates target group "webtg".

aws_lb: This module creates the application Load Balancer "web-lb".

aws_lb_listener: This is to create Load balancer Listener and attaching to "web-lb" Load Balancer.

aws_autoscaling_group: Creating autoscaling group "webasg" and attaching Launch Template "weblt".

aws_autoscaling_policy: Creating autoscaling policy to scale up or scale down according to the load balancer request to the targets.

Note: Scale-up will be happening once for every "ALBRequestCountPerTarget" is 10 continously for 90secs and Scale-down will be happening automatically if there's no load after 5mins.



LB_ENDPOINT_URL: By telling this “Load Balance Endpoint URL” will be coming as an output where you get access to the homepage saying “Cisco SPL”.

Note: Please access the URL after 3 mins as autoscaling will create the ec2 instances in the backend and adds to the target group.

