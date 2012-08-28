require 'spec_helper'

describe "institutes/new" do
  before(:each) do
    assign(:institute, stub_model(Institute).as_new_record)
  end

  it "renders new institute form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => institutes_path, :method => "post" do
    end
  end
end
