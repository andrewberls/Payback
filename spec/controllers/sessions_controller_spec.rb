require 'spec_helper'

def post_login(user)
  post :create, email: user.email, password: 'password'
end

describe SessionsController do
  before do
    cookies.delete(:auth_token)
  end

  let(:user) { FactoryGirl.create(:user, password: 'password') }

  it 'is available to all users' do
    get :new
    response.status.should == 200
  end

  it 'fails if any fields are blank' do
    post :create, email: user.email
    flash[:error].should == 'Invalid email or password'

    post :create, password: 'password'
    flash[:error].should == 'Invalid email or password'
  end

  it 'fails if credentials are incorrect' do
    post :create, email: 'admin@admin.com', password: 'wrongpass'
    expect(response).to render_template(:new)
    flash[:error].should == 'Invalid email or password'
  end


  it 'log in user if credentials are correct' do
    post :create, email: user.email, password: 'password'
    response.should redirect_to new_group_path
  end

  it 'redirects signed in users' do
    post_login(user)
    user.auth_token.should == cookies[:auth_token]
    get :new
    response.should redirect_to expenses_path
  end

  context 'logout' do
    before { post_login(user) }

    it 'logs out signed in users' do
      user.auth_token.should == cookies[:auth_token]
      get :destroy
      cookies[:auth_token].should be_blank
      response.should redirect_to root_url
    end

    it 'does nothing for signed out users' do
      cookies.delete(:auth_token)
      get :destroy
      response.should redirect_to root_url
    end
  end
end
