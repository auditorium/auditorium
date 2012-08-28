require 'spec_helper'

describe "faculties/edit" do
  before(:each) do
    @faculty = assign(:faculty, stub_model(Faculty))
  end

  it "renders the edit faculty form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => faculties_path(@faculty), :method => "post" do
    end
  end
end
