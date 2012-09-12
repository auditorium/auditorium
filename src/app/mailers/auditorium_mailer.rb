class AuditoriumMailer < ActionMailer::Base
  default from: "do-not-reply@auditorium.inftex.net"

  def welcome_email(user)
  	@user = user
    @url = "http://auditorium.inftex.net"
    mail(to: @user.email, subject: 'Welcome to auditorium. Your account has been confirmed.')
  end

  def membership_changed(course, user, membership_type)
  	@user = user
  	@url = course_url(course)
  	@course = course 

  	mail(to: @user.email, 
  		subject: "You are now a #{membership_type} of #{course.name_with_term}.", 
  		template_path: "auditorium_mailer",
  		template_name: "#{membership_type}_membership")
  end
end
