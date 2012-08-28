require "spec_helper"

describe InstitutesController do
  describe "routing" do

    it "routes to #index" do
      get("/institutes").should route_to("institutes#index")
    end

    it "routes to #new" do
      get("/institutes/new").should route_to("institutes#new")
    end

    it "routes to #show" do
      get("/institutes/1").should route_to("institutes#show", :id => "1")
    end

    it "routes to #edit" do
      get("/institutes/1/edit").should route_to("institutes#edit", :id => "1")
    end

    it "routes to #create" do
      post("/institutes").should route_to("institutes#create")
    end

    it "routes to #update" do
      put("/institutes/1").should route_to("institutes#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/institutes/1").should route_to("institutes#destroy", :id => "1")
    end

  end
end
