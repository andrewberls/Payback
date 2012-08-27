ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)

require "test/unit"
require "mocha"

# Bit hacky here due to the way expense associations are architectured.
# Since expenses get cloned among debtors, you can't do something like
# user.debts.include?(debt). Instead, we check for field &
# association matches. It's probably good enough.

def has_debt_to?(debtor, creditor, debt)
  # I give John $5. John has debt to me.
  found_debt = debtor.debts.detect do |d|
    d.title == debt.title &&
    d.amount == debt.amount &&
    d.creditor == creditor
  end

  found_debt.present?
end

def has_credit_to?(creditor, debtor, credit)
  # I give John $5. I have credit to John
  # (therefore John has a debt to me)
  has_debt_to?(debtor, creditor, credit)
end
