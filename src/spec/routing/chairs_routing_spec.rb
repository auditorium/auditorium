require "spec_helper"

describe ChairsController do
  describe "routing" do

    it "routes to #index" do
      get("/chairs").should route_to("chairs#index")
    end

    it "routes to #new" do
      get("/chairs/new").should route_to("chairs#new")
    end

    it "routes to #show" do
      get("/chairs/1").should route_to("chairs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/chairs/1/edit").should route_to("chairs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/chairs").should route_to("chairs#create")
    end

    it "routes to #update" do
      put("/chairs/1").should route_to("chairs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/chairs/1").should route_to("chairs#destroy", :id => "1")
    end

  end
end
