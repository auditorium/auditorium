namespace :email do
	desc "Sending daily email to users."
	task :daily => :environment do
		email = EmailSettingsController.new
		email.daily
	end
end
