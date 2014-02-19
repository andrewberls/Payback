require 'spec_helper'

describe GroupsController do
  let(:user)     { User.make! }
  let(:nonowner) { User.make! }
  let(:group)    { Group.make! }

  before do
    login_user(user)
    group.initialize_owner(user)
    group.add_user(nonowner)
  end

  it 'redirects unless user is the group' do
    nongroup_user = User.make!
    logout!
    login_user(nongroup_user)
    [:show,:edit,:update].each do |action|
      get action, id: group.gid
      expect(response).to redirect_to expenses_path
    end
  end

  context '#create' do
    let(:params) do
      { 'group' => { 'title' => 'My Group' } }
    end

    it 'creates a group' do
      expect { post :create, params }.to change { Group.count }.by(1)
      expect(response).to redirect_to group_path(Group.last.gid)
    end

    it 'sets the owner' do
      post :create, params
      Group.last.owner.should == user
    end
  end

  context '#show' do
    it 'redirects if the user does not own the group' do
      logout!
      login_user(nonowner)
      get :show, id: group.gid
      expect(response).to redirect_to groups_path
    end

    it 'redirects unless the user count is 1' do
      get :show, id: group.gid
      expect(response).to redirect_to groups_path
    end
  end

  context '#edit' do
    it 'does not redirect if user owns the group' do
      get :edit, id: group.gid
      expect(response).to be_success
    end

    it 'redirects if the user does not own the group' do
      logout!
      login_user(nonowner)
      get :edit, id: group.gid
      expect(response).to redirect_to groups_path
    end
  end

  context '#leave' do
    it 'removes the user' do
      group.users.should include user
      post :leave, id: group.gid
      group.reload
      group.users.should_not include user
      #group.owner.should be_nil
    end
  end


  describe 'invitations' do

    before { logout! }

    context '#invitations - signed in' do
      let(:recipient) { User.make! }
      let(:inv) do
        Invitation.make!(sender: user, group: group, recipient_email: recipient.email)
      end

      it 'automatically completes for logged in users' do
        login_user(recipient)
        group.users.should_not include recipient
        get :invitations, token: inv.token
        expect(response).to redirect_to groups_path
        group.reload.users.should include recipient
      end

      it 'marks the invitation as used' do
        login_user(recipient)
        inv.should_not be_used
        get :invitations, token: inv.token
        inv.reload.should be_used
      end
    end

    context '#invitations - not signed in' do
      let(:recipient_email) { 'jane@doe.com' }

      let(:inv) do
        Invitation.make!(sender: user, group: group, recipient_email: recipient_email)
      end

      let(:params) do
        {
          token: inv.token,
          full_name: 'Jane Doe',
          email: recipient_email,
          password: 'password'
        }
      end

      it 'renders a form for the user to sign up' do
        get :invitations, token: inv.token
        expect(response).to render_template :invitations
      end

      it 'lets a new user join the group' do
        expect { post :invitations, params }.to change { User.count }.by(1)
        expect(response).to redirect_to groups_path
        user = User.last
        user.full_name.should == 'Jane Doe'
        user.email.should == 'jane@doe.com'
      end
    end

    context 'invalid invitations' do
      let(:recipient_email) { 'jane@doe.com' }

      let(:inv) do
        Invitation.make!(sender: user, group: group, recipient_email: recipient_email)
      end

      let(:params) do
        {
          token: inv.token,
          full_name: 'Jane Doe',
          email: recipient_email,
          password: 'password'
        }
      end

      before { logout! }

      it 'fails if the invitation is already used' do
        inv.update_attributes!(used: true)
        post :invitations, params
        expect(response).to redirect_to expenses_path
      end

      it 'fails if the user already belongs to the group' do
        user = User.create!(full_name: 'Jane Doe', email: 'jane@doe.com',
                     password: 'password', password_confirmation: 'password')
        group.add_user(user)
        post :invitations, params
        assigns(:invitation).should == inv
        assigns(:group).should == group
        expect(response).to render_template :join
      end
    end
  end
end
