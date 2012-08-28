class Users::ConfirmationsController < Devise::ConfirmationsController

	def create
		Rails.logger.debug "CREATE"
		Rails.logger.debug "RESOURCES: #{resource_params[:email]}"
		if resource_params[:email].match /tu-dresden.de$/
			Rails.logger.debug "TU DRESDEN!"
			self.resource = resource_class.send_confirmation_instructions(resource_params)
		
	    if successfully_sent?(resource)
	      respond_with({}, :location => after_resending_confirmation_instructions_path_for(resource_name))
	    else
	      respond_with(resource)
	    end
	  else
	  	Rails.logger.debug "NO TU DRESDEN! :("
	  	redirect_to root_url, :flash => { :notice => "Your account needs to be approved by the moderator. If it is approved, you'll be notified."}
    end
	end

end