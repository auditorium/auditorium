module DeviseHelper

	def devise_error_messages! 
    if resource.errors.empty?
      return ""  
    else
      resource.errors.full_messages.map { |msg| flash[:error] = msg }.join 
      ""
    end
	end 
end	