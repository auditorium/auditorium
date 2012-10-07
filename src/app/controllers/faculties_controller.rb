class FacultiesController < ApplicationController

  load_and_authorize_resource

  # GET /faculties
  # GET /faculties.json
  def index
    @faculties = Faculty.all
    @faculties_with_courses = current_user.faculties_with_courses

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @faculties }
    end
  end

  # GET /faculties/1
  # GET /faculties/1.json
  def show
    @faculty = Faculty.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @faculty }
    end
  end

  # GET /faculties/new
  # GET /faculties/new.json
  def new
    @faculty = Faculty.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @faculty }
    end
  end

  # GET /faculties/1/edit
  def edit
    @faculty = Faculty.find(params[:id])
  end

  # POST /faculties
  # POST /faculties.json
  def create
    @faculty = Faculty.new(params[:faculty])

    respond_to do |format|
      if @faculty.save
        format.html { redirect_to @faculty, notice: 'Faculty was successfully created.' }
        format.json { render json: @faculty, status: :created, location: @faculty }
      else
        format.html { render action: "new" }
        format.json { render json: @faculty.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /faculties/1
  # PUT /faculties/1.json
  def update
    @faculty = Faculty.find(params[:id])

    respond_to do |format|
      if @faculty.update_attributes(params[:faculty])
        format.html { redirect_to @faculty, notice: 'Faculty was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @faculty.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /faculties/1
  # DELETE /faculties/1.json
  def destroy
    @faculty = Faculty.find(params[:id])
    @faculty.destroy

    respond_to do |format|
      format.html { redirect_to faculties_url }
      format.json { head :no_content }
    end
  end
end
