require 'spec_helper'

describe "institutes/edit" do
  before(:each) do
    @institute = assign(:institute, stub_model(Institute))
  end

  it "renders the edit institute form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => institutes_path(@institute), :method => "post" do
    end
  end
end
