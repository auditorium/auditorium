module HomeHelper
  
	def show_all_posts 
		true if !params[:post_filter].eql? 'infos' and !params[:post_filter].eql? 'questions' and !cookies[:post_filter].eql? 'info' and !cookies[:post_filter].eql? 'question'
	end

	def show_only_questions
		true if params[:post_filter].eql? 'questions' or cookies[:post_filter].eql? 'question'
	end

	def show_only_infos
		true if params[:post_filter].eql? 'infos' or cookies[:post_filter].eql? 'info'
	end

	def show_all_courses
		true if !params[:course_filter].eql? 'subscribed' and !cookies[:course_filter].eql? 'subscribed'
	end

	def show_only_subscribed_courses
		true if params[:course_filter].eql? 'subscribed' or cookies[:course_filter].eql? 'subscribed'
	end

	def toggle_course_filter_caption
		(params[:course_filter].eql? 'subscribed' or cookies[:course_filter].eql? 'subscribed') ? 'show only subscribed' : 'show only subscribed'
	end

	def toggle_course_filter_value
		(params[:course_filter].eql? 'subscribed' or cookies[:course_filter].eql? 'subscribed') ? 'all' : 'subscribed'
	end

	def toggle_course_filter_current_class
		(params[:course_filter].eql? 'subscribed' or cookies[:course_filter].eql? 'subscribed') ? 'current' : nil
	end

  def post_types
    ['question', 'info']
  end
end
