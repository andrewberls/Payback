require 'spec_helper'

describe PaymentsController do
  let(:user) { User.make! }
  let(:exp1) { Expense.make!(debtor: user) }
  let(:exp2) { Expense.make!(debtor: user) }

  let(:params) do
    {
      payment: {
        expense_ids: exp1.id.to_s,
        creditor_id: exp1.creditor.id,
        debtor_id: exp1.debtor.id,
        title: exp1.title,
        amount: exp1.amount
      }
    }
  end

  before { login_user(user) }

  it 'creates a payment for a single expense' do
    expect { post :create, params }.to change { Payment.count }.by(1)
    Payment.last.expenses.should match_array [exp1]
  end

  it 'creates a payment for multiple expenses' do
    params[:payment][:expense_ids] = [exp1.id, exp2.id].join(',')
    expect { post :create, params }.to change { Payment.count }.by(1)
    Payment.last.expenses.should match_array [exp1, exp2]
  end
end
