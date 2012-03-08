require 'spec_helper'
require 'user'

describe User do  

	before do
		@user = User.new(name: "Example User", email: "user@example.com")
	end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }

  it { should be_valid } # be_foo => foo?

  describe "when name is not present" do
  	before { @user.name = "" }
  	it { should_not be_valid }
  end

end
