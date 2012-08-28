class PeriodsController < ApplicationController

  load_and_authorize_resource

  # GET /periods
  # GET /periods.json
  def index
    @periods = Period.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @periods }
    end
  end

  # GET /periods/1
  # GET /periods/1.json
  def show
    @period = Period.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @period }
    end
  end

  # GET /periods/new
  # GET /periods/new.json
  def new
    @period = Period.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @period }
    end
  end

  # GET /periods/1/edit
  def edit
    @period = Period.find(params[:id])
  end

  # POST /periods
  # POST /periods.json
  def create
    
    params[:period] = calculate_minute_of_day(params[:period])
    
    @period = Period.new(params[:period])
    
    respond_to do |format|
      if @period.save
        format.html { redirect_to @period, notice: 'Period was successfully created.' }
        format.json { render json: @period, status: :created, location: @period }
      else
        format.html { render action: "new" }
        format.json { render json: @period.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /periods/1
  # PUT /periods/1.json
  def update
    @period = Period.find(params[:id])
    params[:period] = calculate_minute_of_day(params[:period])
    respond_to do |format|
      if @period.update_attributes(params[:period])
        format.html { redirect_to @period, notice: 'Period was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @period.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /periods/1
  # DELETE /periods/1.json
  def destroy
    @period = Period.find(params[:id])
    @period.destroy

    respond_to do |format|
      format.html { redirect_to periods_url }
      format.json { head :no_content }
    end
  end
  
  def calculate_minute_of_day(period)
    hour = params["minute_of_day(4i)"].to_i
    minute = params["minute_of_day(5i)"].to_i
    period[:minute_of_day] = hour*60 + minute
    
    period.delete_if {|key, value| key == "minute_of_day(4i)" or key == "minute_of_day(5i)" }
  end
end
