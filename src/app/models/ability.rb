class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    alias_action :following, :to => :follow
    alias_action :answering, :to => :answer
    alias_action :commenting, :to => :comment
    alias_action :rating, :to => :rate
    alias_action :answered, :to => :mark_as_answered
    alias_action :search_courses, :to => :search_for_courses
    alias_action :announcements, :to => :read_announcements


    user ||= User.new # guest user (not logged in)

    if user.id? # registrierte Benutzer

      can :search, :all

      can :read, :all #if user.confirmed?
      can :mark_all_as_read, Notification
      can :mark_as_read, Notification
      can :destroy, Notification
      cannot :read, Report

      can :update,   User, :id => user.id
      can :moderate, User, user.is_admin?
      cannot :search, User

      can :create,   Post
      can :read_announcements, Course

      can :update,   Post do |post|
        post.author_id == user.id or post.course.moderators.include? user or post.course.editors.include? user
      end
      
      cannot :read, Post do |post|
          post.origin.is_private? and !(post.author_id == user.id or post.course.moderators.include? user or post.course.editors.include? user)
      end

      can :destroy,  Post do |post|
        post.author_id == user.id or post.course.moderators.include? user or post.course.editors.include? user
      end

      can :comment,  Post
      can :report,   Post do |post|
        user.id != post.author.id
      end
      can :answer,   Post
      can :rate,     Post do |post|
        user.id != post.author.id
      end

      can :mark_as_answered, Post do |post|
        user.id == post.parent.author.id
      end

      # can :post_in, Course do |course|
      #   user.is_course_member? course
      # end

      can :announce_in, Course do |course|
        user.is_course_editor? course or user.is_course_maintainer? course
      end

      #can :follow, Course do |course| course.faculty.id == user.faculty_id end
      can :create, Lecture
      can :create, Course
      can :follow, Course
      can :read, Course
      can :manage, Course do |course|
        user.is_course_maintainer? course or user.is_course_editor? course or user.admin?
      end

      cannot :manage_users, Course do |course|
        !user.is_course_maintainer?(course)
      end

      cannot :delete, Course do |course|
        !user.is_course_maintainer? course
      end

      can :follow, Lecture
      can :follow, Faculty
      cannot :approve, Course

      cannot :manage, Feedback
      can :create, Feedback

      cannot :manage, Term
      can :read, Term
      can :search_for_courses, Term
      can :search, User
      
    else # Gäste
      cannot :read, :all
    end

    if user.admin?  # admin
      can :manage, :all
      can :destroy, :all
      can :read, :all #if user.confirmed?
      can :update, :all

      can :rate,     Post do |post|
        user.id != post.author.id
      end
      can :manage, Feedback
      can :manage_users, Course
    end


    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
