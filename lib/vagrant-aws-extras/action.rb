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
						builder.use Call, DNS::ProviderIsAWS do |env, aws_builder|
							if env[:result]
								aws_builder.use	::VagrantPlugins::AWS::Action::ConnectAWS
								aws_builder.use ::VagrantPlugins::AWS::Action::ReadSSHInfo
								aws_builder.use DNS::ConnectAWS
								aws_builder.use DNS::Set
							end
						end
					end
				end

				def self.action_destroy
					Vagrant::Action::Builder.new.tap do |builder|
						builder.use Call, DNS::ProviderIsAWS do |env, aws_builder|
							if env[:result]
								aws_builder.use	::VagrantPlugins::AWS::Action::ConnectAWS
								aws_builder.use ::VagrantPlugins::AWS::Action::ReadSSHInfo
								aws_builder.use DNS::ConnectAWS			
								aws_builder.use DNS::Remove
							end
						end
					end
				end

				action_root = Pathname.new(File.expand_path("../action", __FILE__))
				autoload :DNS, action_root.join("dns")
			end
		end
	end
end