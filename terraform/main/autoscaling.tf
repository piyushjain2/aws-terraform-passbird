resource "aws_launch_configuration" "pb-lc" {
  name_prefix     = "${local.purpose_id}-${local.env_id}-"
  image_id        = data.aws_ami.amazon-linux.id
  instance_type   = "t2.micro"
  user_data       = file("./files/user_data.sh")
  security_groups = [aws_security_group.pb-sg-instance.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "pb-asg" {
  name                 = "${local.purpose_id}-${local.env_id}-asg"
  min_size             = 1
  max_size             = 4
  desired_capacity     = 2
  launch_configuration = aws_launch_configuration.pb-lc.name
  vpc_zone_identifier  = module.vpc.private_subnets
 target_group_arns     = [ aws_lb_target_group.pb-tg.arn ]
  tag {
    key                 = "Environment"
    value               = local.env_id
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "pb-asg-attach" {
  autoscaling_group_name = aws_autoscaling_group.pb-asg.id
  lb_target_group_arn    = aws_lb_target_group.pb-tg.arn
}