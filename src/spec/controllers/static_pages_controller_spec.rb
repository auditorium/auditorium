require 'spec_helper'

describe StaticPagesController do

  describe "GET 'imprint'" do
    it "returns http success" do
      get 'imprint'
      response.should be_success
    end
  end

  describe "GET 'privacy'" do
    it "returns http success" do
      get 'privacy'
      response.should be_success
    end
  end

  describe "GET 'story'" do
    it "returns http success" do
      get 'story'
      response.should be_success
    end
  end

end
