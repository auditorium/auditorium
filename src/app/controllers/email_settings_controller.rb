class EmailSettingsController < ApplicationController
  def new
  end

  def create
  	@email_setting = EmailSetting.new(params[:email_setting])
  	@email_setting.user = current_user
  	respond_to do |format|
      if @email_setting.save!
        format.html { redirect_to edit_user_registration_path, :flash => { :success =>  'Email settings successfully updated.' } }
        format.json { head :no_content }
      else
        format.html { render action:  edit_user_registration_path, :flash => { :error => "Something went wrong with your email settings." } }
        format.json { render json: @email_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  	@email_setting = EmailSetting.find_by_user_id(current_user.id)
  end

  def update
  	@email_setting = EmailSetting.find_by_user_id(current_user.id)

  	respond_to do |format|
      if @email_setting.update_attributes(params[:email_setting])
        format.html { redirect_to edit_user_registration_path, :flash => { :success =>  'Email settings successfully updated.' } }
        format.json { head :no_content }
      else
        format.html { render action:  edit_user_registration_path, :flash => { :error => "Something went wrong with your email settings." } }
        format.json { render json: @email_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end

  def change_emails_for_subscriptions
    course_params = params.keep_if{|p| p.match /^course_/ }

    course_params.each do |course_param|
      course_id = course_param[0].split('_')[1]
      membership = CourseMembership.find_by_course_id_and_user_id(course_id, current_user.id)

      membership.receive_emails = (course_param[1] == 'on' ? true : false) 
      membership.save
    end

    respond_to do |format|
      format.html { redirect_to edit_user_registration_path, :flash => {:success => 'Updated email settings for subscriptions.'} }
    end  
  end
end
