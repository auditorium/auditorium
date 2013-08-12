module ApplicationHelper
  class CodeRayify < Redcarpet::Render::HTML
    def block_code(code, language='ruby')
      if language.nil? or not language.match /^\w+$/
        language = "ruby" 
      end
      
      CodeRay.scan(code, language).div
    end

    def link(link, title, alt_text)
      if link.match /^https?:\/\/auditorium.inf.tu-dresden.de/
        "<a href=\"#{link}\">#{alt_text}</a>"
      else
        "<a target=\"_blank\" href=\"#{link}\"  title='external link to #{link}'> <i class='icon-external-link'></i> #{alt_text}</a>"
      end
    end

    def autolink(link, link_type)
      if link.match /^https?:\/\/auditorium.inf.tu-dresden.de/
        "<a href=\"#{link}\">#{link}</i></a>"
      else
        "<a target=\"_blank\" href=\"#{link}\" title='external link to #{link}'><i class='icon-external-link'></i> #{link}</a>"
      end
    end
  end

  def markdown(text)
    coderayified = CodeRayify.new()

    options = {
      :fenced_code_blocks => true,
      :no_intra_emphasis => true,
      :autolink => true,
      :strikethrough => true,
      :lax_html_blocks => true,
      #:superscript => true
    }

    markdown_to_html = Redcarpet::Markdown.new(coderayified, options)
    markdown_to_html.render(text).html_safe
  end

  def comment_markdown(text)
    coderayified = CodeRayify.new()
    options = {
      :fenced_code_blocks => true,
      :no_intra_emphasis => true,
      :autolink => true,
      :strikethrough => true,
      :lax_html_blocks => true,
      :no_styles => true
    }

    markdown_to_html = Redcarpet::Markdown.new(coderayified, options)
    markdown_to_html.render(text).html_safe
  end

  def mathjax_should_load
    %w{questions announcements topics groups home}.include? params[:controller]
  end

  #==========
  # below old stuff...




  def weekdays
    %w{monday tuesday wednesday thursday friday saturday sunday}
  end
  
  def event_types
    ['lecture', 'excercise', 'seminar', 'lab']
  end
  
  def post_types
    ['answer', 'question', 'comment']
  end

  def group_types
    ['lecture', 'learning', 'topic']
  end
  
  def term_types
    { "ss" => "Summer Semester", "ws" => "Winter Semester", "tri1" => "1. Trisemester", "tri2" => "2. Trisemester", "tri3" => '3. Trisemester' }
  end
  
  def week_rotation
    ['every week', 'odd week', 'even week']
  end

  def current_term
    Term.where("beginDate < ?", Date.today).where("endDate > ?", Date.today)[0]
  end

  def item_parents
    if params[:action] == 'show'
      case params[:controller]
      when "faculties"
        item = @faculty
      when "institutes"
        item = @institute
      when "chairs"
        item = @chair
      when "lectures"
        item = @lecture
      when "courses"
        item = @course
      end
      parents = []
      while !item.nil?
        parents.push item
        item = item.parent
      end
      parents.reverse!
      return parents
    end
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    direction = (column == params[:sort] && params[:direction] == "asc") ? "desc" : "asc"
    link_to title, :sort => column, :direction => direction
    link_to title, {:sort => column, :direction => direction}, {:class => "icon-caret-down sort_#{direction}"}
  end
  
  def should_be_disabled?
    if current_user
      return false
    else
      return true
    end
  end

  def show_link(object, content = "Show")
    link_to(content, object) if can?(:read, object)
  end

  def edit_link(object, content = "Edit")
    link_to(content, [:edit, object]) if can?(:update, object)
  end

  def destroy_link(object, content = "Destroy")
    link_to(content, object, :method => :delete, :confirm => "Are you sure?") if can?(:destroy, object)
  end

  def create_link(object, content = "New")
    if can?(:create, object)
      object_class = (object.kind_of?(Class) ? object : object.class)
      link_to(content, [:new, object_class.name.underscore.to_sym])
    end
  end

  def admins
    User.find_all(:admin => true)
  end

  
  def available_title
    %w{Dr. Prof. Doz.}
  end

  def shorten (string, length)
    if string.length > length
      "#{string[0,length]}..."
    else
      string
    end

  end

  def unread_membership_requests
    membership_requests = MembershipRequest.where(:read => false).keep_if { |m| can? :manage, m and !m.read? } 
    membership_requests = Kaminari.paginate_array(membership_requests).page(params[:mr_page]).per(10)
  end

  def user_from_email(user)
    if !user.email.match /@mail.zih.tu-dresden.de$/
      prefix = user.email.split('@')[0]
      "#{prefix.split('.')[0].to_s.titleize} #{prefix.split('.')[1].to_s.titleize}"
    else
      prefix = user.email.split('@')[0]
    end
  end

  def membership_type?(membership_request)
    if membership = CourseMembership.find_by_user_id_and_course_id(membership_request.user.id, membership_request.course.id)
      membership.membership_type
    else
      "no membership"
    end
  end

  # helper methods for login form
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def rating_points(points)
    points.to_i > 0 ? "+#{points}" : points 
  end

  def post_type?(post)
    post.post_type.eql?('info') ? 'announcement' : post.post_type 
  end

  def notifications_for_user_in(course)
    current_user.notifications.keep_if{|n| !n.read? and course.posts.map(&:id).include? n.notifyable_id if n.notifyable_type.eql? 'Post'}
  end

  def tag_list_delimited(tag_array)
    tag_array.map(&:name).map { |t| link_to t, tag_path(t) }.join(', ').html_safe
  end

end
