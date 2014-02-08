require 'spec_helper'

describe Group do
  let(:group) { Group.make! }

  context 'validations' do
    it 'is not valid without a title' do
      group.title = ''
      group.should_not be_valid
    end

    it 'is not valid when the title is too long' do
      group.title = 'a' * 51
      group.should_not be_valid
    end
  end

  context 'gid' do
    it 'be generated before save' do
      group.gid.should be_present
    end

    it "be six characters long" do
      group.gid.length.should == 6
    end
  end

  it 'sets the owner' do
   owner = User.make!

   group.initialize_owner(owner)
   group.save!

   group.owner.should == owner
   owner.owned.should == [ group ]
   owner.groups.should == [ group ]
  end

  context 'users' do
    let(:user)  { User.make! }

    before { group.add_user(user) }

    it 'can add users' do
      group.users.should include user
      user.groups.should include group
    end

    it 'can remove users' do
      group.remove_user(user)

      group.users.should_not include user
      user.groups.should_not include group
    end

    it 'deactivates users expenses' do
      creditor = User.make!
      debtor   = User.make!
      expense  = Expense.make!(creditor: creditor, debtor: debtor)
      expense.group.remove_user(creditor)

      expense.reload.should_not be_active
    end

    it 'computes peers' do
      user2 = User.make!
      group.add_user(user2)
      group.peers(user).should == [user2]
    end
  end

  context '#total_exchanged' do
    let(:creditor) { User.make! }
    let(:debtor)   { User.make! }
    let!(:exp1)    { Expense.make!(group: group, creditor: creditor, debtor: debtor, amount: 2) }
    let!(:exp2)    { Expense.make!(group: group, creditor: creditor, debtor: debtor, amount: 3) }

    it 'computes the total' do
      group.total_exchanged.should == 5
    end
  end

end
