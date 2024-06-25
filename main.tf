resource "aws_launch_template" "first-template" {
  # Name of the launch template
  name          = "first-template"

  # ID of the Amazon Machine Image (AMI) to use for the instance
  image_id      = "ami-0264a899947b7d068"

  # Instance type for the EC2 instance
  instance_type = "t2.micro"

  # SSH key pair name for connecting to the instance
  key_name = "keypair"

  #Block device mappings for the instance
 block_device_mappings {
   device_name = "/dev/sdf"

    ebs {
      volume_size = 10
    }
     }
  
# Network interface configuration
  network_interfaces {
    # Associates a public IP address with the instance
    associate_public_ip_address = true

    # Security groups to associate with the instance
    security_groups = ["sg-0aa99d1ba9c5021bf"]
  }

  # Tag specifications for the instance
  tag_specifications {
    # Specifies the resource type as "instance"
    resource_type = "instance"

    # Tags to apply to the instance
    tags = {
      Name = "first template"
    }
  }
}

resource "aws_instance" "instance-template" {
       instance_type = "t2.micro"
       launch_template {
         id = aws_launch_template.first-template.id
         version = "$Latest"
       }
       tags = {
         Name = "template-instance"
       }
}
  resource "aws_autoscaling_group" "template-instance" {
  # Name of the Auto Scaling Group
  name               = "template-instance"

  # Desired number of instances in the Autoscaling Group
  desired_capacity   = 2

  # Minimum and maximum number of instances in the Autoscaling Group
  min_size           = 2
  max_size           = 6

  # Availability Zone(s) where instances will be launched
  availability_zones = ["eu-west-2b"]

  # ID of the launch template to use for launching instances in the Autoscaling Group
  launch_template {
    id      = aws_launch_template.first-template.id

    # Use the latest version of the launch template
    version = "$Latest"
  }

}