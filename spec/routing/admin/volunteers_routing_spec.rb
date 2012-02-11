require "spec_helper"

describe Admin::VolunteersController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/volunteers").should route_to("admin/volunteers#index")
    end

    it "routes to #new" do
      get("/admin/volunteers/new").should route_to("admin/volunteers#new")
    end

    it "routes to #show" do
      get("/admin/volunteers/1").should route_to("admin/volunteers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/volunteers/1/edit").should route_to("admin/volunteers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/volunteers").should route_to("admin/volunteers#create")
    end

    it "routes to #update" do
      put("/admin/volunteers/1").should route_to("admin/volunteers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/volunteers/1").should route_to("admin/volunteers#destroy", :id => "1")
    end

  end
end
