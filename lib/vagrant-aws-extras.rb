require "pathname"
require "vagrant-aws-extras/plugin"

module VagrantPlugins
  module AWS
  	module Extras
		  def self.source_root
		  	@source_root ||= Pathname.new(File.expand_path("../../", __FILE__))
		  end
		end
  end
end