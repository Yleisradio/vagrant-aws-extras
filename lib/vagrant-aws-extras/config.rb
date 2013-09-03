require "vagrant"

module VagrantPlugins
  module AWS
  	module Extras
  		class Config < Vagrant.plugin("2", :config)  			
  			# The record zone for machine
  			#
  			# @return [String]
  			attr_accessor :record_zone

  			# The record type for machine
  			#
  			# @return [String]
	  		attr_accessor :record_type
	    
				# The record name for machine
  			#
  			# @return [String]
	  		attr_accessor :record_name

	  		# The record ttl value for machine
  			#
  			# @return [Integer]
	  		attr_accessor :record_ttl
	    
	    	# The flag for remove dns record on suspend
	    	#
	    	# @return [Boolean]
	    	attr_accessor :remove_on_suspend

				# The flag for remove dns record on destroy
	    	#
	    	# @return [Boolean]
	    	attr_accessor :remove_on_destroy

	    	def initialize 
	    		@record_zone = UNSET_VALUE
	    		@record_type = UNSET_VALUE
	    		@record_name = UNSET_VALUE
	    		@record_ttl = UNSET_VALUE
	    		@remove_on_suspend = UNSET_VALUE
	    		@remove_on_destroy = UNSET_VALUE
	    	end

	    	def finalize!
	    		@record_zone 		 	 = nil if @record_zone == UNSET_VALUE	
	    		@record_type 			 = "CNAME" if @record_type == UNSET_VALUE
	    		@record_name 		 = nil if @record_name == UNSET_VALUE
	    		@record_ttl 			 = 3600 if @record_ttl == UNSET_VALUE
	    		@remove_on_suspend = true if @remove_on_suspend == UNSET_VALUE
	    		@remove_on_destroy = true if @remove_on_destroy == UNSET_VALUE
	    	end

	    	def validate(machine)
	    		errors = []
	    		errors.push "record zone must be set" unless @record_zone
	    		errors.push "record name must be set" unless @record_name

	    		if errors.any?
	    			return {"aws.extras" => errors}
	    		else
	    			return {}
	    		end
	    	end

	    end
  	end	
  end
end