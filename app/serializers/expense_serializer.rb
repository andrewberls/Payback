# == Schema Information
#
# Table name: expenses
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  creditor_id :integer
#  debtor_id   :integer
#  group_id    :integer
#  amount      :decimal(10, 2)
#  active      :boolean          default(TRUE)
#  action      :string(255)
#

class ExpenseSerializer < ActiveModel::Serializer
  attributes :id, :title, :amount, :action, :active, :group_id, :created_at, :updated_at

  has_one :creditor
  has_one :debtor
end
