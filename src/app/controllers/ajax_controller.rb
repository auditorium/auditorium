class AjaxController < ApplicationController
  def courses
  	if params[:term]
      like= "%".concat(params[:term].concat("%"))
      courses = Course.where("name like ?", like).limit(10)
    else
      courses = Course.all(limit: 10)
    end
    list = courses.map {|c| Hash[ id: c.id, label: (c.name_with_term short: false), name: (c.name_with_term short: false)]}
    render json: list
  end

  def lectures
    if params[:term]
      like= "%".concat(params[:term].concat("%"))
      lectures = Lecture.where("name like ?", like).limit(10)
    else
      lectures = Lecture.all(limit: 10)
    end
    list = lectures.map {|c| Hash[ id: c.id, label: c.name, name: c.name]}
    render json: list
  end

  def chairs
    if params[:term]
      like= "%".concat(params[:term].concat("%"))
      chairs = Chair.where("name like ?", like).limit(10)
    else
      chairs = Chair.all(limit: 10)
    end
    list = chairs.map {|c| Hash[ id: c.id, label: c.name, name: c.name]}
    render json: list
  end
end
