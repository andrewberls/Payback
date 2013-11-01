require 'spec_helper'

describe User do
  context 'validations' do
    let(:user) { FactoryGirl.create(:user) }

    subject { user }

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
    let(:user) { User.make! }
    let(:expense) { Expense.make!(debtor_id: user.id) }
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
end
