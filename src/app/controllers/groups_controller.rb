class GroupsController < ApplicationController

	def index
		if params[:tag]
			@groups = Group.tagged_with(params[:tag])
		else
			@groups = Group.order(:title)
		end
	end

	def new
		@group = Group.new

		respond_to do |format|
			format.html
		end
	end

	def create
		@group = Group.new(params[:group])

		respond_to do |format|
			if @group.save!
				format.html { redirect_to @group, notice: t('groups.create.success') }
			else
				format.html { redirect_to 'new', error: t('groups.create.failure') }
			end
		end
	end
end
