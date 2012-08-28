require 'spec_helper'

describe "chairs/edit" do
  before(:each) do
    @chair = assign(:chair, stub_model(Chair))
  end

  it "renders the edit chair form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => chairs_path(@chair), :method => "post" do
    end
  end
end
