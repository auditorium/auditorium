class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    alias_action :moderation, :to => :moderate
    alias_action :my_groups, :to => :goto_my_groups
    alias_action :following, :to => :follow
   
    user ||= User.new # guest user (not logged in)

    if user.id? # registrierte Benutzer
      can :read, :all
      can :follow, Group
      can :my_groups, Group 
      can :manage, Notification do |notification|
        user.notifications.include? notification
      end

      cannot :read, Question do |question|
        question.is_private and !(question.group.is_moderator? user) and user != question.author
      end
      can :create, Question
      #cannot :manage, :all

      # user is group moderator
      can :manage, Group do |group|
        group.is_moderator? user or group.creator == user
      end

      can :read, Group do |group|
        group.deactivated == false or user == group.creator
      end

      cannot :approve, Group 
      cannot :decline, Group
      cannot :delete, Group do |group|
        user != group.creator
      end

      can :manage, MembershipRequest do |mr|
        mr.group.creator == user or mr.group.is_moderator? user
      end

      can :confirm, MembershipRequest do |mr|
        mr.group.creator == user or mr.group.is_moderator? user
      end

      can :reject, MembershipRequest do |mr|
        mr.group.creator == user or mr.group.is_moderator? user
      end

      can :make, MembershipRequest do |mr|
        !(mr.group.creator == user or mr.group.is_moderator? user)
      end
      # cannot :read, Group do |group|
      #   group.deactivated == true and user != group.creator
      # end
      can :manage, User do |visited_user|
        (visited_user.id == user.id)
      end
      
      can :manage, Setting, user_id: user.id
      cannot :confirm, User
      cannot :moderate, User

      can :manage, Question do |question| 
        question.author_id == user.id or (question.persisted? and question.group.is_moderator? user)
      end

      can :manage, Announcement do |announcement| 
        announcement.author_id == user.id or (announcement.persisted? and announcement.group.is_moderator? user)
      end

      can :manage, Topic do |topic| 
        topic.author_id == user.id or (topic.persisted? and topic.group.is_moderator? user)
      end
      can :manage, Answer do |answer| 
        answer.author_id == user.id or (answer.persisted? and answer.question.group.is_moderator? user)
      end

      can :manage, Comment do |comment| 
        comment.author_id == user.id or (comment.persisted? and comment.origin.group.is_moderator? user)
      end

      can [:create, :read], [Group, Comment, Answer, Topic, Announcement]
      cannot [:read, :manage], [Level, Badge]

      can :toggle_as_helpful, Answer do |answer|
        answer.question.author.id == user.id if answer.question.author.present?
      end
    else # Gäste
      cannot :read, :all
    end

    if user.admin?  # admin
      can :manage, :all
      can :moderate, User
      can :confirm, User
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
