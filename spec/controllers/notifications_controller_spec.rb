require 'spec_helper'

describe NotificationsController do
  context '#read' do
    let(:user) { User.make! }
    let(:n1) { Notification.make!(user_to: user, read: false) }
    let(:n2) { Notification.make!(user_to: user, read: false) }

    before { login_user(user) }

    it 'marks all notifications as read' do
      [n1,n2].each { |n| n.should_not be_read }
      post :read
      [n1,n2].each { |n| n.reload.should be_read }
    end
  end
end
