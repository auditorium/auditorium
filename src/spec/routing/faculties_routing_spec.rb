require "spec_helper"

describe FacultiesController do
  describe "routing" do

    it "routes to #index" do
      get("/faculties").should route_to("faculties#index")
    end

    it "routes to #new" do
      get("/faculties/new").should route_to("faculties#new")
    end

    it "routes to #show" do
      get("/faculties/1").should route_to("faculties#show", :id => "1")
    end

    it "routes to #edit" do
      get("/faculties/1/edit").should route_to("faculties#edit", :id => "1")
    end

    it "routes to #create" do
      post("/faculties").should route_to("faculties#create")
    end

    it "routes to #update" do
      put("/faculties/1").should route_to("faculties#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/faculties/1").should route_to("faculties#destroy", :id => "1")
    end

  end
end
