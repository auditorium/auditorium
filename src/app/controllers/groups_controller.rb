class GroupsController < ApplicationController

	def index
		if params[:tag]
			@groups = Group.tagged_with(params[:tag])
		else
			@groups = Group.order(:title)
		end
	end

	def show
		@group = Group.find(params[:id])

		respond_to do |format|
			format.html
			format.json { render json: @group }
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

	def edit
		@group = Group.find(params[:id])
	end

	def update
		@group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to @group, notice: t('groups.update.success') }
        format.json { head :no_content }
      else
        format.html { render action: "edit", error: t('groups.update.failure') }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
	end

	# for ajax calls
	def change_group_type
		@group = Group.new(group_type: params[:group_type])
		respond_to do |format|
			format.js
		end
	end

end
