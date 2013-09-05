require "pathname"
require "vagrant/action/builder"
require "vagrant-aws/action/connect_aws"
require "vagrant-aws/action/read_ssh_info"

module VagrantPlugins
	module AWS
		module Extras
			module Action
				include Vagrant::Action::Builtin

				def self.action_up
					Vagrant::Action::Builder.new.tap do |builder|
						builder.use ConfigValidate
						builder.use	::VagrantPlugins::AWS::Action::ConnectAWS
						builder.use ::VagrantPlugins::AWS::Action::ReadSSHInfo
						builder.use DNS::ConnectAWS
						builder.use DNS::Set
					end
				end

				def self.action_destroy
					Vagrant::Action::Builder.new.tap do |builder|
						builder.use ConfigValidate
						builder.use	::VagrantPlugins::AWS::Action::ConnectAWS
						builder.use ::VagrantPlugins::AWS::Action::ReadSSHInfo
						builder.use DNS::ConnectAWS			
						builder.use DNS::Remove
					end
				end

				action_root = Pathname.new(File.expand_path("../action", __FILE__))
				autoload :DNS, action_root.join("dns")
			end
		end
	end
end