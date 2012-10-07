class InstitutesController < ApplicationController

  load_and_authorize_resource

  # GET /institutes
  # GET /institutes.json
  def index
    @institutes = Institute.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @institutes }
    end
  end

  # GET /institutes/1
  # GET /institutes/1.json
  def show
    @institute = Institute.find(params[:id])

    @chairs = Kaminari.paginate_array(@institute.chairs).page(params[:page]).per(9)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @institute }
    end
  end

  # GET /institutes/new
  # GET /institutes/new.json
  def new
    @institute = Institute.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @institute }
    end
  end

  # GET /institutes/1/edit
  def edit
    @institute = Institute.find(params[:id])
  end

  # POST /institutes
  # POST /institutes.json
  def create
    @institute = Institute.new(params[:institute])

    respond_to do |format|
      if @institute.save
        format.html { redirect_to @institute, notice: 'Institute was successfully created.' }
        format.json { render json: @institute, status: :created, location: @institute }
      else
        format.html { render action: "new" }
        format.json { render json: @institute.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /institutes/1
  # PUT /institutes/1.json
  def update
    @institute = Institute.find(params[:id])

    respond_to do |format|
      if @institute.update_attributes(params[:institute])
        format.html { redirect_to @institute, notice: 'Institute was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @institute.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /institutes/1
  # DELETE /institutes/1.json
  def destroy
    @institute = Institute.find(params[:id])
    @institute.destroy

    respond_to do |format|
      format.html { redirect_to institutes_url }
      format.json { head :no_content }
    end
  end
end
