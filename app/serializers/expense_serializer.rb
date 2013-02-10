class ExpenseSerializer < ActiveModel::Serializer
  attributes :id, :title, :amount, :action, :active, :group_id, :created_at, :updated_at

  has_one :creditor
  has_one :debtor
end
