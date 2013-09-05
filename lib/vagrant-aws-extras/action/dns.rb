require "log4r"
require "fog"
require "ipaddr"

module VagrantPlugins
	module AWS
		module Extras
			module Action
				module DNS
					class ConnectAWS
						def initialize(app, env)
							@app = app 
							@logger = Log4r::Logger.new("vagrant_aws_extras::action::dns")
						end

						def call(env)
							env[:aws_dns_settings] = dns_config = env[:machine].config.aws_extras

							region = env[:machine].provider_config.region
							domain = dns_config.record_zone
							region_config = env[:machine].provider_config.get_region_config(region)

							fog_config = {
            		:provider => :aws
          		}

							fog_config[:aws_access_key_id] = region_config.access_key_id
							fog_config[:aws_secret_access_key] = region_config.secret_access_key
						
							fog_config[:endpoint] = region_config.endpoint if region_config.endpoint
							fog_config[:version]  = region_config.version if region_config.version

							if fog_config
								@logger.info("Connecting to AWS Route53.")
								env[:aws_dns] = ::Fog::DNS.new(fog_config)
								env[:aws_dns_zone] = env[:aws_dns].zones.detect { |zone| zone.domain == domain }
							else
								@logger.info("AWS not configured.")
							end
							@app.call(env)
						end
					end
					class Set
						def initialize(app, env)
							@app = app 
							@logger = Log4r::Logger.new("vagrant_aws_extras::action::dns::set")
						end

						def call(env)
							@logger.info("Set DNS name")
							env[:machine_dns_record] = set(env) if env[:aws_dns_zone].records
							@app.call(env)
						end

						def set(env)
							record_type = !(IPAddr.new(env[:machine_ssh_info][:host]) rescue nil).nil? ? "A" : "CNAME" 

							if existing_record = env[:aws_dns_zone].records.get(env[:aws_dns_settings].record_name)
								existing_record.modify({
									:name => env[:aws_dns_settings].record_name,
									:value => env[:machine_ssh_info][:host],
									:type => record_type,
									:ttl => env[:aws_dns_settings].record_ttl
								})
							else
								existing_record = env[:aws_dns_zone].records.create({
									:name => env[:aws_dns_settings].record_name,
									:value => env[:machine_ssh_info][:host],
									:type => record_type,
									:ttl => env[:aws_dns_settings].record_ttl
								})
							end
							existing_record
						end
					end

					class Remove
						def initialize(app, env)
							@app = app 
							@logger = Log4r::Logger.new("vagrant_aws_extras::action::dns::remove")
						end

						def call(env)
							@logger.info("Remove DNS name")
							env[:machine_dns_record] = remove(env) if env[:aws_dns_zone].records
							@app.call(env)
						end

						def remove(env)
							if existing_record = env[:aws_dns_zone].records.detect { |record| record.value.include?(env[:machine_ssh_info][:host]) }
								existing_record.destroy
							end
						end
					end
				end
			end
		end
	end
end