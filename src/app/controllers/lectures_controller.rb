class LecturesController < ApplicationController

  load_and_authorize_resource

  # GET /lectures
  # GET /lectures.json
  def index
    if params[:chair_id]
      @lectures = Lecture.where('chair_id = ?', params[:chair_id]) 
    else
      @lectures = Lecture.all
    end

    @lectures = Kaminari.paginate_array(@lectures).page(params[:page]).per(10)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lectures }
    end
  end

  # GET /lectures/1
  # GET /lectures/1.json
  def show
    @lecture = Lecture.find(params[:id])

    do_redirect = false
    do_redirect = params[:noredirect].nil? or
    params[:noredirect].to_i != 1 or
    params[:noredirect] != "true"

    respond_to do |format|
        if do_redirect and @lecture.has_current_course?
          format.html { redirect_to @lecture.current_course, :flash => { :info => 'You were redirected to the current course.' } }
          format.json { render json: @lecture.current_course }
        else
          format.html
          format.json { render json: @lecture }
        end  # show.html.erb
    end
  end

  # GET /lectures/new
  # GET /lectures/new.json
  def new
    @lecture = Lecture.new
    @chairs = Chair.all
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lecture }
    end
  end

  # GET /lectures/1/edit
  def edit
    @lecture = Lecture.find(params[:id])

    @chairs = Chair.all
  end

  # POST /lectures
  # POST /lectures.json
  def create
    @lecture = Lecture.new(params[:lecture])

    respond_to do |format|
      if @lecture.save

        # create course
        @course = Course.create!(:name => @lecture.name,
                                :description => @lecture.description,
                                :url => @lecture.url,
                                :lecture_id => @lecture.id,
                                :term_id => params[:term_id])
        if current_user.is_admin?
          @course.approved = true
          flash_message = 'Course was successfully created.' 
        else
          @course.approved = false
          @course.creator = current_user
          flash_message = 'Course was successfully suggested. Our moderators will check it. But you can already ask questions if you want.'
          @course.save!
        end

        format.html { redirect_to @lecture, notice: 'Lecture was successfully created.' }
        format.json { render json: @lecture, status: :created, location: @lecture }
      else
        format.html { render action: "new" }
        format.json { render json: @lecture.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lectures/1
  # PUT /lectures/1.json
  def update
    @lecture = Lecture.find(params[:id])

    respond_to do |format|
      if @lecture.update_attributes(params[:lecture])
        format.html { redirect_to @lecture, notice: 'Lecture was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lecture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lectures/1
  # DELETE /lectures/1.json
  def destroy
    @lecture = Lecture.find(params[:id])
    @lecture.destroy

    respond_to do |format|
      format.html { redirect_to lectures_url }
      format.json { head :no_content }
    end
  end

  def search

    @lectures = Lecture.where('name LIKE ?', "%#{params[:q]}%").limit(40).page(params[:page]).per(10)

    respond_to do |format|
      format.js
    end
  end
end
