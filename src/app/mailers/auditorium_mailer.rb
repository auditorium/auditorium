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

  def private_question(user, post)
  	@user = user
  	@course = post.course
  	@url = course_url(post.course)
  	@post = post
  	membership = CourseMembership.find_by_course_id_and_user_id(@course.id, @user.id)
    @membership_type = membership.membership_type if !membership.nil?

    if @user.is_admin? and not (@membership_type.eql? 'maintainer' or @membership_type.eql? 'editor')
      @template = 'private_question_admin'
    else
      @template = 'private_question'
    end

  	mail(to: @user.email,
  		subject: "#{@post.author.full_name} asked a private question in #{@course.name_with_term}.",
  		template_path: 'auditorium_mailer',
  		template_name: @template)
  end
end
