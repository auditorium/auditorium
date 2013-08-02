module UserMacros
  def login(user)
    user.confirm!
    sign_in user
  end
end