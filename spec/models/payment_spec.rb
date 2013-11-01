require 'spec_helper'

describe Payment do
  let(:payment) { FactoryGirl.build(:payment) }

  it 'sends a notification after creation' do
    expect { payment.save! }.to change { Notification.count }.by(1)
  end
end
