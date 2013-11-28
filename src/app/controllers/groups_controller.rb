class GroupsController < ApplicationController
	load_and_authorize_resource

	def index

    cookies[:show_topic_groups] = params[:show_topic_groups] if params[:show_topic_groups].present?
    cookies[:show_study_groups] = params[:show_study_groups] if params[:show_study_groups].present?
    cookies[:show_lecture_groups] = params[:show_lecture_groups] if params[:show_lecture_groups].present?
    cookies[:show_only_subscribed_groups] = params[:show_only_subscribed_groups] if params[:show_only_subscribed_groups].present?

    group_types = Array.new
		group_types << ['topic'] unless cookies[:show_topic_groups] == 'no'
    group_types << ['study'] unless cookies[:show_study_groups] == 'no'
    group_types << ['lecture'] unless cookies[:show_lecture_groups] == 'no'
    
    @groups = Group.where(group_type: group_types).order(:title).delete_if { |g| g.deactivated == true and (current_user != g.creator and !current_user.admin?)}
    @groups = @groups.keep_if{ |g| g.followers.include? current_user } if cookies[:show_only_subscribed_groups] == 'yes'
    @groups = filter_by_tags(@groups)

    @groups = Kaminari.paginate_array(@groups).page(params[:page]).per(21)
    @tag_ids = cookies[:group_filter_tag_ids].present? ? Tag.where(id: cookies[:group_filter_tag_ids].split(',')) : []
    respond_to :js, :html
	end

  def tagged
    @groups = Group.tagged_with(params[:tag]).order(:title)
    @groups = Kaminari.paginate_array(@groups).page(params[:page]).per(21) 

    render :index
  end

  def my_groups
    cookies[:show_topic_groups] = params[:show_topic_groups] if params[:show_topic_groups].present?
    cookies[:show_study_groups] = params[:show_study_groups] if params[:show_study_groups].present?
    cookies[:show_lecture_groups] = params[:show_lecture_groups] if params[:show_lecture_groups].present?

    group_types = Array.new
    group_types << ['topic'] unless cookies[:show_topic_groups] == 'no'
    group_types << ['study'] unless cookies[:show_study_groups] == 'no'
    group_types << ['lecture'] unless cookies[:show_lecture_groups] == 'no'
    
    @groups = current_user.groups.where(group_type: group_types).order(:title)
    @groups = filter_by_tags(@groups)

    @groups = Kaminari.paginate_array(@groups).page(params[:page]).per(21)
    @tag_ids = cookies[:group_filter_tag_ids].present? ? Tag.where(id: cookies[:group_filter_tag_ids].split(',')) : []
    render :index
  end

	def show
		@group = Group.find(params[:id])

    @question = @group.questions.build
    @question.tags = @group.tags

    @announcement = @group.announcements.build
    @announcement.tags = @group.tags

    @topic = @group.topics.build
    @topic.tags = @group.tags

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

    @group.approved = true if current_user.admin?
		
		respond_to do |format|
			if @group.save
				format.html { redirect_to group_path(@group), success: t('groups.create.success') }
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
        format.html { redirect_to @group, notice: t('groups.flash.updated') }
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
			format.html { redirect_to groups_path, notice: t('groups.flash.destroyed') }
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

  def show_members_list 
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

        format.html { redirect_to groups_path, flash: { success:  t('groups.flash.following', group: @group) } }
        format.js
      elsif method.eql? 'unfollow' 
        @group.followers.delete current_user if @group.followers.include? current_user

        format.html { redirect_to groups_path, flash: { success:  t('groups.flash.unfollowing', group: @group) } }
        format.js
      end
    end
	end

  def approve
    @group = Group.find(params[:id])

    @group.approved = true
    @group.save

    respond_to do |format|
      format.html { redirect_to @group, notice: t('groups.flash.approved') }
    end
  end

  def decline
    @group = Group.find(params[:id])
    @group.deactivated = true
    @group.approved = true
    @group.save
    respond_to do |format|
      format.html { redirect_to @group, notice: t('groups.flash.declined') }
    end
  end

  def reactivate
    @group = Group.find(params[:id])
    @group.deactivated = false
    @group.save
    respond_to do |format|
      format.html { redirect_to @group, notice: t('groups.flash.reactivated') }
    end
  end

  private
  def filter_by_tags(groups)
    if params[:tags]
      cookies[:group_filter_tag_ids] = params[:tags]
      tag_ids = params[:tags].split(',').collect { |i| i.to_i }.to_set
      groups = groups.keep_if { |g| tag_ids.subset? g.tags.map(&:id).to_set  }
    elsif cookies[:group_filter_tag_ids]
      tag_ids = cookies[:group_filter_tag_ids].split(',').collect { |i| i.to_i }.to_set
      groups = groups.keep_if { |g| tag_ids.subset? g.tags.map(&:id).to_set  }
    else 
      groups
    end
  end

end
