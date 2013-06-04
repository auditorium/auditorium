module PostsHelper
  def label_class(type)
    case type
      when "question" then "label-important"
      when "answer" then "label-success"
      when "comment" then "label-inverse"
    end
  end

  def highlight_post(post, course)
    if post.author.presence 
  	 !(post.post_type.eql? 'info' or post.post_type.eql? 'recording') and (post.author.is_course_editor? course or post.author.is_course_maintainer? course)
    end
  end
end
