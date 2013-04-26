class RecordingsController < ApplicationController
	load_and_authorize_resource :course
  load_and_authorize_resource :recording, :through => :course
	before_filter :get_course

	def get_course
		@course = Course.find(params[:course_id])
	end

	def index
		@recordings = @course.recordings
	end

	def show 
		@recording = Post.find(params[:id])
	end

	def new
		@recording = @course.recordings.build
	end

	def create
		@recording = @course.recordings.new(params[:recording])
		@recording.author = current_user
		respond_to do |format|
			if @recording.save
				format.html { redirect_to [@course, @recording], notice: t('recording.action.created') }
				format.json { render json: [@course, @recording], status: :created, location: [@course, @recording] }
			else
				format.html { render action: 'new' }
				format.json { render json: @recording.errors, status: :unprecessable_entity }
			end
		end
	end

	def update
	end

	def destroy
	end

	def comment
		@recording = Recording.find(params[:id])

		@comment = Post.new(params[:post])
		@comment.author = current_user
		@comment.parent_id = @recording.id
		@comment.course_id = @course.id
		@comment.post_type = 'comment'
		@comment.subject = @comment.body

		respond_to do |format|
			if @comment.save!
				format.html { redirect_to [@course, @recording], notice: t('recording.action.commented') }
				format.json { render json: [@course, @recording], status: :created, location: [@course, @recording] }
			else
				format.html { render 'show' }
				format.json { render json: @comment.errors, status: :unprecessable_entity }
			end
		end
	end
end
