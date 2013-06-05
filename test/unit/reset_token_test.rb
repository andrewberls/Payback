require File.expand_path('../../test_helper',  __FILE__)

class ResetTokenTest < Test::Unit::TestCase
  context "reset token" do
    setup do
      @admin = User.find_by_email!('admin@admin.com')
      @token = ResetToken.new(user: @admin)
    end

    should "generate a token before save" do
      @token.save!
      assert @token.token.present?
    end

    # TODO: functional test?
    should "be invalid if expired" do

    end

    should "be invalid if already used" do

    end

    should "invalidate previous open tokens on create" do

    end

  end
end
