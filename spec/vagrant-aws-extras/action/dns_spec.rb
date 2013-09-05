require "fog"
require "rspec"
require "vagrant-aws-extras/action/dns"

Fog.mock!

describe VagrantPlugins::AWS::Extras::Action::DNS do
	
	describe VagrantPlugins::AWS::Extras::Action::DNS::ConnectAWS do
		let(:instance) { described_class.new(mock('config'), mock('app')) }

	  # Ensure tests are not affected by AWS credential environment variables
	  before :each do
	    ENV.stub(:[] => nil)
	  end

		it "return zone"
	end

	describe VagrantPlugins::AWS::Extras::Action::DNS::Set do
		let(:instance) { described_class.new(mock('config'), mock('app')) }

	  # Ensure tests are not affected by AWS credential environment variables
	  before :each do
	    ENV.stub(:[] => nil)
	  end

		it "set record"
	end

	describe VagrantPlugins::AWS::Extras::Action::DNS::Remove do
		let(:instance) { described_class.new(mock('config'), mock('app')) }

	  # Ensure tests are not affected by AWS credential environment variables
	  before :each do
	    ENV.stub(:[] => nil)
	  end

		it "destroy record"
	end

end