require 'spec_helper'

describe "chairs/new" do
  before(:each) do
    assign(:chair, stub_model(Chair).as_new_record)
  end

  it "renders new chair form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => chairs_path, :method => "post" do
    end
  end
end
