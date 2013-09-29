require 'spec_helper'

describe Invitation do
  let(:admin) { FactoryGirl.create(:user) }
  let(:group) { FactoryGirl.create(:group) }
  let(:inv) do
    FactoryGirl.build(:invitation, sender: admin, group: group,
                      recipient_email: 'nicole@gmail.com')
  end

  it 'generates a token before save' do
    inv.save!
    inv.token.should be_present
  end

  # TODO: fix to work with async delivery
  # it "sends an email with the correct content" do
  #   inv.save!
  #   mail    = ActionMailer::Base.deliveries.last || raise("no delivery found")
  #   to_addr = mail['to'].to_s
  #   subj    = mail['subject'].to_s
  #   body    = mail.body.to_s

  #   group_title = inv.group.title

  #   to_addr.should == 'nicole@gmail.com'
  #   subj.should    == "Invitation to join #{group_title} on Payback.io"
  #   body.should include "#{inv.sender.full_name} has invited you to join their group '#{group_title}'"
  #   body.should include "http://payback.io/invitations/#{inv.token}"
  # end

  it 'lets a new user join the group' do

  end

  it 'lets a logged in user join the group' do

  end

  it 'is invalid if group already includes recipient' do

  end

  it 'is invalid if already used' do

  end
end
