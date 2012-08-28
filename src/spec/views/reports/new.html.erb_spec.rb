require 'spec_helper'

describe "reports/new" do
  before(:each) do
    assign(:report, stub_model(Report).as_new_record)
  end

  it "renders new report form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => reports_path, :method => "post" do
    end
  end
end
