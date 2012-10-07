class FeedbacksController < ApplicationController
  load_and_authorize_resource

  def index
    @feedbacks = Feedback.order('created_at DESC').page(params[:page]).per(10)
  end

  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(params[:feedback])

    if request.env["HTTP_REFERER"]
      redirect_url = request.env["HTTP_REFERER"]
    else
      redirect_url = :back
    end

    respond_to do |format|
      if @feedback.save
        format.js
      else
        format.html { redirect_to redirect_url, flash: { success: 'Something went wrong, try again in a little while' } }  
      end
    end
  end

  def destroy
    @feedback = Feedback.find(params[:id])
    @feedback.destroy

    respond_to do |format|
      format.html{redirect_to feedbacks_path, flash: { success: 'Feedback has been removed.' } }  
    end
  end

  def mark_as_read
    @feedback = Feedback.find(params[:id])

    @feedback.read = true
    
    respond_to do |format|
      if @feedback.save
        format.js
      else
        format.html{ redirect_to feedbacks_path, flash: { success: 'Something went wrong, try again in a little while' } }  
      end
    end

  end
end
