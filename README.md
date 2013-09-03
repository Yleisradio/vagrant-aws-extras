Vagrant AWS Extras
===================

Create DNS record for box on Vagrant up
Destroy DNS record on Vagrant destroy


TODO
----

1. Write tests/specs
2. Add tweak configuration 
3. Add support for other fog.io providers
4. Release production ready version
5. ???


Sample Config
-------------

		Vagrant.configure('2') do |config|

		  config.vm.define "aws-box" do |box|
		    box.vm.box = "dummy"
		    box.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
		    box.aws_extras.record_zone = "mydomain.com."
		    box.aws_extras.record_name = "aws-box.mydomain.com."
		    box.aws_extras.record_type = "CNAME"
		    box.aws_extras.record_ttl = "60"

		    box.vm.provider "aws" do |provider, override|
		      provider.tags = { "Name" => "Vagrant plugin test box"}
		    end
		  end

		  config.vm.provider :aws do |aws, override|
		    # Get these from: https://console.aws.amazon.com
		    aws.access_key_id = ENV['AWS_ACCESS_KEY']
		    aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']

		    # Get these from: https://console.aws.amazon.com/ec2
		    aws.keypair_name = ENV['AWS_KEYPAIR']
		    override.ssh.private_key_path = ENV['AWS_PRIVATE_KEY_PATH']

		    # Security group for deployment
		    aws.security_groups = [ 'your-security-group-id' ]

		    # AWS region and instance size
		    aws.region = "eu-west-1"

		    # eu-west-1 & 14.04 LTS i386
		    aws.ami = "ami-6975691d"

		    override.ssh.username = "ubuntu"
		  end
		end