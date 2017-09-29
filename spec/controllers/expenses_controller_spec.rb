require 'spec_helper'

describe ExpensesController do
  let(:creditor)      { User.make! }
  let(:group)         { Group.make! }
  let(:user1)         { User.make! }
  let(:user2)         { User.make! }
  let(:nongroup_user) { User.make! }

  before { login_user(creditor) }

  context 'create' do
    let(:params) do
      {
        'expense' => {
          'amount' => '20',
          'title' => 'Electric bill'
        },
        'group' => { 'gid' => group.gid },
        'users' => {
          user1.id => 'on',
          user2.id => 'on',
        },
        'tag_list' => 'household,utilities',
        'commit' => Expense::PAYBACK_COPY
      }
    end

    let(:household_tag) { Tag.make!(title: 'household') }
    let(:utilities_tag) { Tag.make!(title: 'utilities') }

    before do
      [creditor, user1, user2].each { |u| group.add_user(u) }
    end

    context 'invalid  parameters' do
      it 'prevents invalid expense parameters' do
        params['expense']['amount'] = ''
        expect { post :create, params }.to change { Expense.count }.by(0)
        expect(response).to render_template :new
      end

      it 'prevents invalid user parameters' do
        params['users'] = {}
        expect { post :create, params }.to change { Expense.count }.by(0)
        expect(response).to render_template :new
      end

      it 'prevents users outside allowed groups' do
        params['users'] = { nongroup_user.id => 'on' }
        expect { post :create, params }.to change { Expense.count }.by(0)
        expect(response).to render_template :new
      end
    end

    context 'valid parameters' do
      before do
        Tag.should_receive(:find_or_create_by_title).with('household').and_return(household_tag)
        Tag.should_receive(:find_or_create_by_title).with('utilities').and_return(utilities_tag)
      end

      it 'creates multiple expenses' do
        expect { post :create, params }.to change { Expense.count }.by(2)
      end

      it 'sets creditors/debtors' do
        post :create, params
        exp1, exp2 = Expense.last(2)

        exp1.creditor.should == creditor
        exp1.debtor.should == user1

        exp2.creditor.should == creditor
        exp2.debtor.should == user2
      end

      it 'sets amounts' do
        post :create, params
        exp1, exp2 = Expense.last(2)

        exp1.amount.should == 10
        exp2.amount.should == 10
      end

      it 'redirects properly' do
        post :create, params
        expect(response).to redirect_to expenses_path
      end
    end
  end


  context 'clear' do
    let(:debtor) { User.make! }
    let(:exp1) { Expense.make!(creditor: creditor, debtor: debtor) }
    let(:exp2) { Expense.make!(creditor: creditor, debtor: debtor) }

    let(:params) do
      { id: debtor.id }
    end

    it 'deactivates all current credits to a user' do
      [exp1, exp2].each { |e| e.should be_active }
      post :clear, params
      expect(response).to redirect_to expenses_path
      [exp1, exp2].each { |e| e.reload.should be_inactive }
    end
  end

end
