begin
  require "vagrant"
rescue LoadError 
  raise "The Vagrant AWS Extras plugin must be run with Vagrant"
end

if Vagrant::VERSION < "1.2.0"
  raise "The Vagrant AWS Extras plugin is only compatible with Vagrant 1.2+"
end

module VagrantPlugins
  module AWS
    module Extras
      class Plugin < Vagrant.plugin('2')
        name 'AWS Extras'

        description <<-DESC
          This plugin extends AWS plugin
        DESC

        config(:aws_extras) do
          require_relative 'config'
          Config
        end
        
        %w{up}.each do |action|
          action_hook(:set_dns_record, "machine_action_#{action}".to_sym) do |hook|
            require_relative 'action'
            hook.append VagrantPlugins::AWS::Extras::Action.action_up
          end
        end
        
        %w{destroy}.each do |action|
          action_hook(:remove_dns_record, "machine_action_#{action}".to_sym) do |hook|
            require_relative 'action'
            hook.append VagrantPlugins::AWS::Extras::Action.action_destroy
          end
        end

      end
    end
  end
end