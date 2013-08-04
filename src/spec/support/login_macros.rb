include Warden::Test::Helpers
Warden.test_mode!

module UserMacros
  def login(user)
    user.confirm!
    sign_in user
  end

  def login_with(user)
    user.confirm!
    login_as(user, scope: :user)
  end
end