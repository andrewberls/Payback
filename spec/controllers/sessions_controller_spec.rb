require 'spec_helper'

describe SessionsController do
  let(:user) { User.make!(password: 'password') }

  let(:params) do
    {
      email: user.email,
      password: 'password'
    }
  end

  before { logout! }

  it 'is available to all users' do
    get :new
    response.status.should == 200
  end

  it 'fails if any fields are blank' do
    post :create, email: user.email
    expect(response).to render_template :new
    flash[:error].should == 'Invalid email or password'

    post :create, password: 'password'
    expect(response).to render_template :new
    flash[:error].should == 'Invalid email or password'
  end

  it 'fails if credentials are incorrect' do
    post :create, email: user.email, password: 'wrongpass'
    expect(response).to render_template :new
    flash[:error].should == 'Invalid email or password'
  end


  it 'log in user if credentials are correct' do
    post :create, params
    expect(response).to redirect_to new_group_path
  end

  it 'redirects signed in users' do
    post :create, params
    user.auth_token.should == cookies[:auth_token]

    get :new
    response.should redirect_to expenses_path
  end

  context '#destroy' do
    before { login_user(user) }

    it 'logs out signed in users' do
      user.auth_token.should == cookies[:auth_token]
      get :destroy
      cookies[:auth_token].should be_blank
      response.should redirect_to root_url
    end

    it 'does nothing for signed out users' do
      logout!
      get :destroy
      response.should redirect_to root_url
    end
  end

  context '#forgot_password' do
    let(:params) do
      { email: user.email }
    end
    context 'when signed in' do
      before { login_user(user) }

      it 'renders the page' do
        get :forgot_password
        response.should render_template :forgot_password
      end

      it 'rejects invalid emails' do
        post :forgot_password, email: 'doesnotexist@gmail.com'
        response.should render_template :forgot_password
      end

      it 'rejects unauthorized emails' do
        post :forgot_password, email: 'notmyemail@gmail.com'
        response.should render_template :forgot_password
      end

      it 'creates a new reset token' do
        expect { post :forgot_password, params }.to change { ResetToken.count }.by(1)
        ResetToken.last.user.should == user
      end

      it 'redirects after success' do
        post :forgot_password, params
        response.should redirect_to forgot_password_path
      end
    end

    context 'when not signed in' do
      it 'renders the page' do
        get :forgot_password
        response.should render_template :forgot_password
      end
    end
  end

  context '#reset_password' do
    let(:token) { ResetToken.make!(user: user) }

    let(:params) do
      {
        token: token.token,
        password: 'newpassword',
        password_confirmation: 'newpassword'
      }
    end

    it 'rejects used tokens' do
      token.update_attributes!(used: true)
      post :reset_password, params
      flash[:error].should == 'Token is invalid.'
      response.should redirect_to forgot_password_path
    end

    it 'rejects expired tokens' do
      token.expires_at = 10.days.ago; token.save!
      post :reset_password, params
      flash[:error].should == 'Token is invalid.'
      response.should redirect_to forgot_password_path
    end

    it 'rejects incorrect passwords' do
      params[:password_confirmation] = 'does_not_match'
      post :reset_password, params
      response.should render_template :reset_password
    end

    it 'rejects invalid passwords' do
      params[:password] = params[:password_confirmation] = 'x' # Too short
      post :reset_password, params
      response.should render_template :reset_password
    end

    it 'marks tokens as used' do
      token.should_not be_used
      post :reset_password, params
      token.reload.should be_used
    end

    it 'signs in the user' do
      post :reset_password, params
      cookies[:auth_token].should == user.auth_token
    end

    it 'redirects after success' do
      post :reset_password, params
      response.should redirect_to expenses_path
    end
  end

end
