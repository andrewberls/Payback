require File.expand_path('../../test_helper',  __FILE__)

class InvitationTest < Test::Unit::TestCase
  context "invitations" do
    setup do
      @admin = User.find_by_email!('admin@admin.com')
      @group = Group.find_by_title!('Admin Only')
      @inv   = Invitation.new(sender: @admin, group: @group, recipient_email: 'nicole@gmail.com')
    end

    should "generate a token before save" do
      @inv.save!
      assert @inv.token.present?
    end

    # TODO: mailer test
    should "sent an email with the correct content" do
      mail    = ActionMailer::Base.deliveries.last || raise("no delivery found")
      to_addr = mail['to'].to_s
      subject = mail['subject'].to_s
      body    = mail.body.to_s

      assert_equal 'nicole@gmail.com', to_addr
      assert_equal 'Invitation to join Admin Only on Payback.io', subject
      assert body.include? "Admin User has invited you to join their group 'Admin Only'"
      assert body.include? "http://payback.io/invitations/#{@inv.token}"
    end

    # TODO: functional test?
    should "let a new user join the group" do

    end

    should "let a logged in user join the group" do

    end

    should "be invalid if group already includes recipient" do

    end

    should "be invalid if already used" do

    end

  end
end
