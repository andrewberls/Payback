require 'spec_helper'

describe User do
  let(:user)   { User.make! }
  let(:group1) { Group.make! }
  let(:group2) { Group.make! }
  subject { user }

  context 'validations' do
    it { should be_valid }

    it 'is not valid without a full name' do
      subject.full_name = ''
      subject.should_not be_valid
    end

    it 'is not valid when the full name is too long' do
      subject.full_name = 'a' * 51
      subject.should_not be_valid
    end

    it 'is not valid without an email' do
      subject.email = ''
      subject.should_not be_valid
    end

    it 'requires a properly formatted email' do
      %w( user@foo,com user_at_foo.org example.user@foo. ).each do |email|
        subject.email = email
        subject.should_not be_valid
      end
    end

    it 'requires a unique email' do
      existing_user = FactoryGirl.create(:user)
      subject.email = existing_user.email
      subject.should_not be_valid
    end

    it 'is not valid without a password' do
      subject.password = ''
      subject.should_not be_valid
    end

    it "is not valid when the password doesn't match confirmation" do
      subject.password_confirmation = 'mismatch'
      subject.should_not be_valid
    end

    it 'is not valid when the password is too short' do
      subject.password = 'a' * 4
      subject.should_not be_valid
    end

    it 'generates an auth token before save' do
      subject.save!
      subject.auth_token.should be_present
    end
  end

  context 'payments' do
    let(:expense)  { Expense.make!(debtor_id: user.id) }
    let (:payment) { FactoryGirl.build(:payment, debtor_id: user.id) }

    it 'detects when a payment is has not been sent' do
      user.sent_payment_for?(expense).should == false
    end

    it 'detects when a payment is has been sent' do
      payment.expenses << expense
      payment.save!
      user.sent_payment_for?(expense).should == true
    end
  end

  context '#owns?' do
    before  { group1.initialize_owner(user) }
    specify { user.owns?(group1) }
    specify { !user.owns?(group2) }
  end

  context '#expenses' do
    let!(:exp1)  { Expense.make!(creditor: user, group: group1) }
    let!(:exp2)  { Expense.make!(debtor: user, group: group1) }
    let!(:exp3)  { Expense.make!(creditor: user, group: group2) }

    before do
      group1.initialize_owner(user)
      group2.initialize_owner(user)
    end

    it 'computes expenses without a group' do
      user.expenses.should match_array [exp1, exp2, exp3]
    end

    it 'computes expenses given a group' do
      user.expenses(group1).should match_array [exp1, exp2]
    end
  end

  context '#brand_new?' do
    specify { user.should be_brand_new }
    specify do
      Expense.make!(creditor: user, group: group1)
      user.should_not be_brand_new
    end
  end

  context 'notifications' do
    let!(:exp) { Expense.make!(creditor: user) }

    context '#unread_notifications' do
      let!(:notif) { Notification.make!(user_to: user) }
      specify { user.unread_notifications.should == [notif] }
    end

    context '#notified_on?' do
      specify { user.notified_on?(exp) }
      specify do
        Notification.make!(user_from: user, user_to: exp.debtor, expense_id: exp.id)
        user.notified_on?(exp.id).should == true
      end
    end

    context '#can_notify_on?' do
      specify { user.can_notify_on?(exp.id) }
      specify do
        Notification.make!(user_from: user, user_to: exp.debtor, expense_id: exp.id)
        user.can_notify_on?(exp.id).should == false
      end
    end

    context '#recent_notifications' do
      let!(:n1) { Notification.make!(user_to: user) }
      let!(:n2) { Notification.make!(user_to: user) }
      let!(:n3) { Notification.make!(user_to: user) }
      let!(:n4) { Notification.make!(user_to: user) }
      let!(:n5) { Notification.make!(user_to: user) }
      let!(:n6) { Notification.make!(user_to: user) }

      it 'limits the number of read notifications shown' do
        [n1,n2,n3,n4,n5,n6].each { |n| n.update_attributes!(read: true) }
        user.recent_notifications.length.should == 5
        user.recent_notifications.should match_array [n2,n3,n4,n5,n6]
      end

      it 'returns all notifications if any are unread' do
        user.recent_notifications.length.should == 6
        user.recent_notifications.should match_array [n1,n2,n3,n4,n5,n6]
      end
    end
  end

end
