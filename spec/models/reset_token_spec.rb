require 'spec_helper'

describe ResetToken do
  let(:admin) { FactoryGirl.create(:user) }
  let(:token) { FactoryGirl.build(:reset_token, user: admin) }

  before { ResetToken.delete_all }

  it "generates a token before save" do
    token.save!
    token.token.should be_present
  end

  it "is invalid if expired" do
    token.save!
    token.expires_at = 10.days.ago; token.save!

    token.should be_expired
    token.should be_invalid
  end

  it 'is invalid if already used' do
    token.save!
    token.update_attributes! used: true
    token.should be_invalid
  end

  it 'invalidates previous open tokens on create' do
    token.save!
    token.should be_valid

    new_token = admin.generate_reset_token
    token.reload
    token.should be_used
    new_token.should be_valid
  end
end
