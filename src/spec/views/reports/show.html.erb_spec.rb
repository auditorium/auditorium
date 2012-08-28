require 'spec_helper'

describe "reports/show" do
  before(:each) do
    @report = assign(:report, stub_model(Report))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
