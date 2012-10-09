class TermsController < ApplicationController
  load_and_authorize_resource

  # GET /terms
  # GET /terms.json
  def index
    @terms = Term.order("beginDate").reverse

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @terms }
    end
  end

  # GET /terms/1
  # GET /terms/1.json
  def show
    @term = Term.find(params[:id])
    if params[:faculties].eql? 'all' or current_user.faculties.empty?
      @courses = @term.courses  
    else
      @courses = @term.courses.keep_if {|c| current_user.faculties.include? c.faculty  }
    end
    @courses.sort! { |x,y| y.participants.count <=> x.participants.count and y.followers.count <=> x.followers.count }
    @courses = Kaminari.paginate_array(@courses).page(params[:page]).per(20)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @term }
    end
  end

  # GET /terms/new
  # GET /terms/new.json
  def new
    @term = Term.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @term }
    end
  end

  # GET /terms/1/edit
  def edit
    @term = Term.find(params[:id])
  end

  # POST /terms
  # POST /terms.json
  def create
    @term = Term.new(params[:term])

    respond_to do |format|
      if @term.save
        format.html { redirect_to @term, notice: 'Term was successfully created.' }
        format.json { render json: @term, status: :created, location: @term }
      else
        format.html { render action: "new" }
        format.json { render json: @term.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /terms/1
  # PUT /terms/1.json
  def update
    @term = Term.find(params[:id])

    respond_to do |format|
      if @term.update_attributes(params[:term])
        format.html { redirect_to @term, notice: 'Term was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @term.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /terms/1
  # DELETE /terms/1.json
  def destroy
    @term = Term.find(params[:id])
    @term.destroy

    respond_to do |format|
      format.html { redirect_to terms_url }
      format.json { head :no_content }
    end
  end

  def search_courses

    if params[:term_id]
      @courses = Course.where('term_id = ? and name LIKE ?', params[:term_id], "%#{params[:q]}%").limit(20)
    else 
      @courses = Course.where('name LIKE ?', "%#{params[:q]}%").limit(20)
    end

    @courses.sort! { |x,y| y.participants.count <=> x.participants.count and y.followers.count <=> x.followers.count }
    @courses = Kaminari.paginate_array(@courses).page(params[:page]).per(20)

    respond_to do |format|
      format.js
    end
  end
end
