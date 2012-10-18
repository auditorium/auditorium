class ChairsController < ApplicationController

  load_and_authorize_resource

  # GET /chairs
  # GET /chairs.json
  def index
    if params[:institute_id] 
      @chairs = Chair.where('institute_id = ?', params[:institute_id]).order(:name)
    elsif params[:q]
      @chairs = Chair.where('name LIKE ?', "%#{params[:q]}%").limit(42)
    else
      @chairs = Chair.order("name")
    end

    @chairs = Kaminari.paginate_array(@chairs).page(params[:page]).per(9)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @chairs }
    end
  end

  # GET /chairs/1
  # GET /chairs/1.json
  def show
    @chair = Chair.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @chair }
    end
  end

  # GET /chairs/new
  # GET /chairs/new.json
  def new
    @chair = Chair.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @chair }
    end
  end

  # GET /chairs/1/edit
  def edit
    @chair = Chair.find(params[:id])
  end

  # POST /chairs
  # POST /chairs.json
  def create
    @chair = Chair.new(params[:chair])

    respond_to do |format|
      if @chair.save
        format.html { redirect_to @chair, notice: 'Chair was successfully created.' }
        format.json { render json: @chair, status: :created, location: @chair }
      else
        format.html { render action: "new" }
        format.json { render json: @chair.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /chairs/1
  # PUT /chairs/1.json
  def update
    @chair = Chair.find(params[:id])

    respond_to do |format|
      if @chair.update_attributes(params[:chair])
        format.html { redirect_to @chair, notice: 'Chair was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @chair.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chairs/1
  # DELETE /chairs/1.json
  def destroy
    @chair = Chair.find(params[:id])
    @chair.destroy

    respond_to do |format|
      format.html { redirect_to chairs_url }
      format.json { head :no_content }
    end
  end

  def search
    @chairs = Chair.where('name LIKE ?', "%#{params[:q]}%").limit(42).page(params[:page]).per(9)

    respond_to do |format|
      format.js
      format.html { redirect_to search_url(:query => params[:q]) }
    end
  end
end
