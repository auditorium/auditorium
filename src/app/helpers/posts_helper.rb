module PostsHelper
  def label_class(type)
    case type
      when "question" then "label-important"
      when "answer" then "label-success"
      when "comment" then "label-inverse"
    end
  end
end
