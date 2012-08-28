require 'spec_helper'

describe "faculties/new" do
  before(:each) do
    assign(:faculty, stub_model(Faculty).as_new_record)
  end

  it "renders new faculty form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => faculties_path, :method => "post" do
    end
  end
end
