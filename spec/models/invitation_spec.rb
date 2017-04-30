require 'spec_helper'

describe Invitation do
  let(:admin) { FactoryGirl.create(:user) }
  let(:group) { FactoryGirl.create(:group) }
  let(:inv) do
    Invitation.make!(sender: admin, group: group, recipient_email: 'nicole@gmail.com')
  end

  it 'generates a token before save' do
    inv = FactoryGirl.build(:invitation, sender: admin, group: group,
                      recipient_email: 'nicole@gmail.com')
    inv.save!
    inv.token.should be_present
  end

  # it "sends an email with the correct content" do
  #   pending
  # end

  it 'is valid if not used' do
    inv.should_not be_invalid
  end

  it 'is invalid if already used' do
    inv.update_attributes!(used: true)
    inv.should be_invalid
  end
end
