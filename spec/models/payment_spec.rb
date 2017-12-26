# == Schema Information
#
# Table name: payments
#
#  id          :integer          not null, primary key
#  expense_id  :integer
#  creditor_id :integer
#  debtor_id   :integer
#  title       :string(255)
#  amount      :decimal(, )
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Payment do
  let(:payment) { FactoryGirl.build(:payment) }

  it 'sends a notification after creation' do
    expect { payment.save! }.to change { Notification.count }.by(1)
  end
end
