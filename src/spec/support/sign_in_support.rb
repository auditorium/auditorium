include Devise::TestHelpers

module ValidUserHelper
  def signed_in_as_a_valid_user
    @user ||= FactoryGirl.create :user
    @user.confirm!
    @user.save
    sign_in @user
  end

  def signed_in_as_a_valid_admin
    @admin ||= FactoryGirl.create :admin
    @admin.confirm!
    @admin.save
    sign_in @admin
  end
end

# module for helping request specs
module ValidUserRequestHelper
  # for use in request specs
  def sign_in_as_a_valid_user
    @user ||= FactoryGirl.create :user
    @user.confirm!
    @user.save
    post_via_redirect user_session_path, 'user[email]' => @user.email, 'user[password]' => @user.password
  end
end
