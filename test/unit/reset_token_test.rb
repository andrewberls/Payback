require File.expand_path('../../test_helper',  __FILE__)

class ResetTokenTest < Test::Unit::TestCase
  context "reset token" do
    setup do
      ResetToken.delete_all
      @admin = User.find_by_email!('admin@admin.com')
      @token = ResetToken.new(user: @admin)
    end

    should "generate a token before save" do
      @token.save!
      assert @token.token.present?
    end

    should "be invalid if expired" do
      @token.save!
      @token.expires_at = 10.days.ago; @token.save!
      assert @token.expired?
      assert @token.invalid?
    end

    should "be invalid if already used" do
      @token.save!
      @token.update_attributes! used: true
      assert @token.invalid?
    end

    should "invalidate previous open tokens on create" do
      @token.save!
      assert !@token.invalid?

      new_token = @admin.generate_reset_token
      @token.reload
      assert @token.used
      assert !new_token.invalid?
    end

  end
end
