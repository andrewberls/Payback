require 'spec_helper'

describe Group do
  let(:group) { Group.make! }

  subject { group }

  context 'validations' do
    it 'is not valid without a title' do
      subject.title = ''
      subject.should_not be_valid
    end

    it 'is not valid when the title is too long' do
      subject.title = 'a' * 51
      subject.should_not be_valid
    end
  end

  context 'gid' do
    let(:group) { Group.make! }

    subject { group }

    it 'be generated before save' do
      subject.gid.should be_present
    end

    it "be six characters long" do
      subject.gid.length.should == 6
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
    let(:group) { Group.make! }
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
  end

end
