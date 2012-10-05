module ApplicationHelper
  class CodeRayify < Redcarpet::Render::HTML
    def block_code(code, language='ruby')
      CodeRay.scan(code, language).div
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

  def weekdays
    %w{monday tuesday wednesday thursday friday saturday sunday}
  end
  
  def event_types
    ['lecture', 'excercise', 'seminar', 'lab']
  end
  
  def post_types
    ['answer', 'question', 'comment']
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

  def shorten (string, length)
    if string.length > length
      "#{string[0,length]}..."
    else
      string
    end

  end

end
