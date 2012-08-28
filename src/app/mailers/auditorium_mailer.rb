class AuditoriumMailer < ActionMailer::Base
  default from: Devise.mailer_sender

  def welcome_email(user)
    @user = user
    @url = "http://auditorium.inftex.net"
    mail(to: @user.email, subject: 'Welcome to auditorium. Your account was confirmed.')
  end
end
