class GroupsController < ApplicationController
	authorize_resource

	def index
		if params[:tag]
			@groups = Group.tagged_with(params[:tag]).order(:title)
		else
			@groups = Group.order(:title)
		end

    @groups = Kaminari.paginate_array(@groups).page(params[:page]).per(20)
	end

  def my_groups
    @groups = current_user.groups
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
		@group.creator = current_user
		
		respond_to do |format|
			if @group.save
				format.html { redirect_to group_path(@group), notice: t('groups.create.success') }
			else
				format.html { render action: :new, error: t('groups.create.failure') }
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

	def destroy
		@group = Group.find(params[:id])
		@group.destroy

		respond_to do |format|
			format.html { redirect_to groups_path, notice: t('groups.destroy.success') }
			format.json { head :no_content }
		end
	end

	# for ajax calls
	def change_group_type
		@group = Group.new(group_type: params[:group_type])
		respond_to do |format|
			format.js
		end
	end

  def manage_members 
    @group = Group.find(params[:id])
    @members = @group.followers
    respond_to :js
  end

  def search_members
    @group = Group.find(params[:group_id].to_i)

    unless params[:member_query].empty?
      query = "%#{params[:member_query]}%"
      @members = User.where('email LIKE ? or first_name LIKE ? or last_name LIKE ?', query, query, query).order('username ASC, first_name ASC, last_name ASC').limit(10)
    else
      @members = @group.followers
    end

    respond_to :js
  end

  def manage_membership
    method = params[:method]
    role = params[:role]
    @group = Group.find(params[:group_id])
    @member = User.find(params[:member_id])

    if method.eql? 'add'
      if role.eql? 'member'
        @group.add_member @member
      elsif role.eql? 'moderator'
        @group.add_moderator @member
      end
    elsif method.eql? 'remove'
      if role.eql? 'member'
        @group.remove_member @member
      elsif role.eql? 'moderator'
        @group.remove_moderator @member
      end
    end

    respond_to do |format| 
      format.html {redirect_to @group }
      format.js
    end
  end

	def following
		@group = Group.find(params[:id])
    method = params[:method]

    
		respond_to do |format|	
      if method.eql? 'follow'
        @group.followers << current_user unless @group.followers.include? current_user

        format.html { redirect_to groups_path, flash: { success:  'You now follow the group.' } }
        format.js
      elsif method.eql? 'unfollow' 
        @group.followers.delete current_user if @group.followers.include? current_user

        format.html { redirect_to groups_path, flash: { success:  'You are not follow this group anymore' } }
        format.js
      end
    end
	end

end
