require 'spec_helper'

describe StatsController do
  let!(:group) { Group.make! }

  let!(:user)  { User.make! }
  let!(:peer1) { User.make! }
  let!(:peer2) { User.make! }

  let!(:debt1) { Expense.make!(creditor: peer1, debtor: user, amount: 10.0, group: group) }
  let!(:credit1) { Expense.make!(creditor: user, debtor: peer2, amount: 20.0, group: group) }

  before do
    group.initialize_owner(user)
    [peer1,peer2].each { |user| group.add_user(user) }
    login_user(user)
  end

  context '#type_proportions' do
    it 'returns proper JSON' do
      get :type_proportions, gid: group.gid
      response.should be_success
      response_json.should == {
       'stats' => [
         { 'type' => 'debt', 'amt' => 10.0 },
         { 'type' => 'credit', 'amt' => 20.0 }
       ]
      }
    end
  end

  context '#segments' do
    it 'returns all-time info for debts' do
      get :segments, gid: group.gid, type: 'debts'
      response.should be_success
      response_json.should == {
        'stats' => [
          { 'name' => peer1.full_name, 'amt' => 10.0 },
          { 'name' => peer2.full_name, 'amt' => 0.0 }
        ]
      }
    end

    it 'returns all-time info for credits' do
      get :segments, gid: group.gid, type: 'credits'
      response.should be_success
      response_json.should == {
        'stats' => [
          { 'name' => peer1.full_name, 'amt' => 0.0 },
          { 'name' => peer2.full_name, 'amt' => 20.0 }
        ]
      }
    end
  end
end
