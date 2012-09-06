require 'spec_helper'

describe AjaxController do

  describe "GET 'courses'" do
    it "returns http success" do
      get 'courses'
      response.should be_success
    end
  end

end
