module DeviseHelper

	def devise_error_messages! 
    return "" if resource.errors.empty? 

    messages = resource.errors.full_messages.map { |msg| flash.now[:error] = msg }.join 
	end 
end	