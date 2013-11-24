class ConfirmationsController < Devise::ConfirmationsController
	layout "landing_page"
	def create
		if resource_params[:email].match /tu-dresden.de$/
			self.resource = resource_class.send_confirmation_instructions(resource_params)
		
	    if successfully_sent?(resource)
	      respond_with({}, :location => after_resending_confirmation_instructions_path_for(resource_name))
	    else
	      respond_with(resource)
	    end
	  else
	  	redirect_to root_url, :flash => { :notice => "Your account needs to be approved by the moderator. If you don't want to wait you should sign up with your TU Dresden email address e.g., sNumber@mail.zih.tu-dresden.de"}
    end
	end

end