module ApplicationHelper
  # devise helper methods
  class CodeRayify < Redcarpet::Render::HTML
    def block_code(code, language='plain')
      if language.nil? or not language.match /^\w+$/
        language = "plain" 
      end
      
      CodeRay.scan(code, language).div
    end

    def link(link, title, alt_text)
      if link.match /^https?:\/\/auditorium.inf.tu-dresden.de/
        "<a href=\"#{link}\">#{alt_text}</a>"
      else
        "<a target=\"_blank\" href=\"#{link}\"  title='external link to #{link}'><i class='fa fa-external-link'></i> #{alt_text}</a>"
      end
    end

    def autolink(link, link_type)
      if link.match /^https?:\/\/auditorium.inf.tu-dresden.de/
        "<a href=\"#{link}\">#{link}</a>"
      else
        "<a target=\"_blank\" href=\"#{link}\" title='external link to #{link}'><i class='fa fa-external-link'></i> #{link}</a>"
      end
    end
  end

  def is_done?(action)
    action == true ? fa_icon('check-square') : fa_icon('square-o')
  end

  def badge_earned?(badge, user)
    user.badges.include? badge
  end

  def post_url(post)
    case post.class.name 
    when 'Question'
      question_url(post)
    when 'Announcement'
      announcement_url(post)
    when 'Topic'
      topic_url(post)
    when 'Video'
      video_url(post)
    end
  end

  def error_messages!(resource) 
    if resource.errors.empty?
      return ""  
    else
      resource.errors.full_messages.map { |msg| flash[:error] = msg }.join 
      ""
    end
  end 

  def nav_link(title, path, options={}) 
    if current_page?(path)
      link_to title, path, class: "active #{color_scheme}" 
    else
      link_to title, path, class: color_scheme
    end
  end

  def badge_categories
    %w{bronze silver gold platinium}
  end

  def color_scheme 
    params[:controller]
  end

  def markdown(text)
    coderayified = CodeRayify.new()

    options = {
      fenced_code_blocks: true,
      no_intra_emphasis: true,
      autolink: true,
      strikethrough: true,
      #:lax_html_blocks => true,
      #:superscript => true
      filter_html: true
    }

    markdown_to_html = Redcarpet::Markdown.new(coderayified, options)
    markdown = markdown_to_html.render(text) 
    html = content_tag('div', class: 'markdown') do 
      sanitize(markdown, :attributes => %w(target id class style href title alt src width height))
    end
  end

  def comment_markdown(text)
    coderayified = CodeRayify.new()

    options = {
      fenced_code_blocks: true,
      no_intra_emphasis: true,
      autolink: true,
      strikethrough: true,
      #:lax_html_blocks => true,
      #:superscript => true
      filter_html: true
    }

    markdown_to_html = Redcarpet::Markdown.new(coderayified, options)
    markdown = markdown_to_html.render(text) 
    html = content_tag('div', class: 'comment-markdown') do 
      sanitize(markdown, :attributes => %w(target id class style href title alt src width height))
    end
  end

  def tag_list(tag_array, options = { delimiter: ', ' }) 
    if tag_array.size > 0
      tag_array.sort {|x,y| y.name <=> x.name }.map(&:name).map { |t| link_to t, tag_path(CGI.escape t), class: "tag-item #{options[:additional_class]}" }.join(options[:delimiter]).html_safe
    else 
      content_tag('span', t('tags.no_tags'), class: "no-tags").html_safe
    end
  end

  def followers_list_delimited(followers_array)
    followers_array.map(&:full_name).map { |user| link_to user, user_path(user) }.join(', ').html_safe
  end

  def already_upvoted?(post)
    vote = current_user.votings.where(votable_id: post.id, votable_type: post.class.name).first
    vote.present? and vote.value == 1
  end

  def already_downvoted?(post)
    vote = current_user.votings.where(votable_id: post.id, votable_type: post.class.name).first
    vote.present? and vote.value == -1
  end

  def title(page_title)
    content_for :title, page_title.to_s
  end

  def named_date(date)
    case date
    when Date.today
      t('dates.today')
    when Date.yesterday
      t('dates.yesterday')
    else
      l(date, format: :long)
    end
  end

  def group_types
    ['lecture', 'study', 'topic']
  end

  def available_title
    %w{Dr. Prof. Doz.}
  end

  def user_from_email(user)
    if !user.email.match /@mail.zih.tu-dresden.de$/
      prefix = user.email.split('@')[0]
      "#{prefix.split('.')[0].to_s.titleize} #{prefix.split('.')[1].to_s.titleize}"
    else
      prefix = user.email.split('@')[0]
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
end
