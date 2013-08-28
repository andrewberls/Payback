require 'spec_helper'

describe Group do
  let(:group) { FactoryGirl.create(:group) }

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

    it 'is not valid when the password is not present' do
      subject.password = ''
      subject.should_not be_valid
    end

    it "is no valid when the password doesn't match confirmation" do
      subject.password_confirmation = 'mismatch'
      subject.should_not be_valid
    end

    it 'is not valid when the password is too short' do
      subject.password = subject.password_confirmation = 'a' * 4
      subject.should_not be_valid
    end
  end

  context 'gid' do
    let(:group) { FactoryGirl.create(:group) }

    subject { group }

    it 'be generated before save' do
      subject.gid.should be_present
    end

    it "be six characters long" do
      subject.gid.length.should == 6
    end
  end

  it 'sets the owner' do
   owner = FactoryGirl.create(:user)

   group.initialize_owner(owner)
   group.save!

   group.owner.should == owner
   owner.owned.should == [ group ]
   owner.groups.should == [ group ]
  end

  context 'users' do
    let(:group) { FactoryGirl.create(:group) }
    let(:user)  { FactoryGirl.create(:user) }

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
      creditor = FactoryGirl.create(:user)
      debtor   = FactoryGirl.create(:user)
      expense  = FactoryGirl.create(:expense_with_group, creditor: creditor, debtor: debtor)
      expense.group.remove_user(creditor)

      expense.reload.should_not be_active
    end
  end

  # context "expenses" do
  #   setup do
  #     @user = User.find_by_email("admin@admin.com")
  #     @group = Group.find_by_title("221B Baker Street")
  #   end

  #   # TODO: can't check strict expense equality
  #   should "report all credits from a specific user" do
  #     # assert_equal @user.credits, @group.active_credits_for(@user)
  #   end

  #   should "report all debts from a specific user" do
  #     # assert_equal @user.debts, @group.active_debts_for(@user)
  #   end
  # end

  end
