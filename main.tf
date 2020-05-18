#resource "aws_key_pair" "webkey" {
#  key_name = "webkey"
#  public_key = file(var.PATH_TO_PUBLIC_KEY)
#}


#resource "aws_instance" "webserver" {
#  ami             =  lookup(var.AMIS, var.AWS_REGION)
#  instance_type   = "t2.micro"
#  key_name        = aws_key_pair.webkey.key_name
#  vpc_security_group_ids = var.sg_list_id
#  subnet_id       = var.subnet_id1
#  associate_public_ip_address = true
#  user_data = file(var.cook_nginx)
#  tags = {
#    Name = "Webserver"
#  }
#}

#resource "aws_lb_target_group_attachment" "webtgattach" {
#  target_group_arn = aws_lb_target_group.webtg.arn
#  target_id        = aws_instance.webserver.id
#  port             = 80
#}

resource "aws_launch_template" "weblt" {
  name = "weblt"
  image_id = lookup(var.AMIS, var.AWS_REGION)
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t2.micro"
  key_name = var.instancekey
  monitoring {
    enabled = true
  }
  #vpc_security_group_ids = var.sg_list_id
  network_interfaces {
    associate_public_ip_address = true
    security_groups = var.sg_list_id
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web-auto"
    }
  }
  user_data = filebase64(var.cook_nginx)
}



resource "aws_lb_target_group" "webtg" {
  name     = "webtg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.webvpcid
}

resource "aws_lb" "alb" {
  name            = "web-lb"
  internal        = false
  load_balancer_type = "application"
  subnets         = [var.subnet_id1,var.subnet_id2]
  security_groups = var.sg_list_id
  tags = {
    Name    = "web_lb"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webtg.arn
  }
}

resource "aws_autoscaling_group" "webasg" {
  vpc_zone_identifier  = [var.subnet_id1,var.subnet_id2]
  desired_capacity   = 1
  max_size           = 3
  min_size           = 1
  target_group_arns = [aws_lb_target_group.webtg.arn]
  health_check_type = "ELB"
  enabled_metrics = ["GroupDesiredCapacity", "GroupInServiceCapacity", "GroupPendingCapacity", "GroupMinSize", "GroupMaxSize", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupStandbyCapacity", "GroupTerminatingCapacity", "GroupTerminatingInstances", "GroupTotalCapacity", "GroupTotalInstances"] 
  launch_template {
    id      = aws_launch_template.weblt.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "asgautopolicy" {
  name                   = "webasgautopolicy"
  autoscaling_group_name = aws_autoscaling_group.webasg.name
  policy_type = "TargetTrackingScaling"
  estimated_instance_warmup = 90
  target_tracking_configuration {
    predefined_metric_specification {
      #predefined_metric_type = "ASGAverageCPUUtilization"
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label = "${aws_lb.alb.arn_suffix}/${aws_lb_target_group.webtg.arn_suffix}"
    }
  target_value = 10
  }
}

output "LB_ENDPOINT_URL" {
  value       = "http://${aws_lb.alb.dns_name}"
  description = "Application load balancer endpoint URL, Note: please access the URL afetr 3 mins.. autoscaling will create the ec2 instances in the backend and add to the target group"
}
