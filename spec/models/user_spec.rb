require 'spec_helper'
require 'user'

describe User do  

	module UserSpecHelper
	  def valid_user_attributes
	    { :email => 'joe@bloggs.com',	      
	      :password => 'abcdefg' }
	  end
	end

	context "A user (in general)" do
	  include UserSpecHelper

	  setup do
	    @user = User.new
	  end

	  specify "should be valid with a full set of valid attributes" do
	    @user.attributes = valid_user_attributes
	    @user.should_be_valid
	  end

	  # specify "should be invalid without an email" do
	  #   @user.attributes = valid_user_attributes.except(:email)
	  #   @user.should_not_be_valid	    
	  #   @user.email = 'joe@bloggs.com'
	  #   @user.should_be_valid
	  # end

	  # specify "should be invalid without a password" do
	  #   @user.attributes = valid_user_attributes.except(:password)
	  #   @user.should_not_be_valid
	  #   @user.password = 'abcdefg'
	  #   @user.should_be_valid
	  # end

		# specify "should be invalid if password is not between 6 and 12 characters in length" do
		#   @user.attributes = valid_user_attributes.except(:password)
		#   @user.password = 'abcdefghijklm' # 13
		#   @user.should_not_be_valid
		#   @user.password = 'abcde' # 5
		#   @user.should_not_be_valid
		#   @user.password = 'abcdefg' # 7
		#   @user.should_be_valid
		# end

	end

end
