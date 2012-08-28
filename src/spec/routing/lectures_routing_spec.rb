require "spec_helper"

describe LecturesController do
  describe "routing" do

    it "routes to #index" do
      get("/lectures").should route_to("lectures#index")
    end

    it "routes to #new" do
      get("/lectures/new").should route_to("lectures#new")
    end

    it "routes to #show" do
      get("/lectures/1").should route_to("lectures#show", :id => "1")
    end

    it "routes to #edit" do
      get("/lectures/1/edit").should route_to("lectures#edit", :id => "1")
    end

    it "routes to #create" do
      post("/lectures").should route_to("lectures#create")
    end

    it "routes to #update" do
      put("/lectures/1").should route_to("lectures#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/lectures/1").should route_to("lectures#destroy", :id => "1")
    end

  end
end
