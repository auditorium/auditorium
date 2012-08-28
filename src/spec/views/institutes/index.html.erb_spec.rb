require 'spec_helper'

describe "institutes/index" do
  before(:each) do
    assign(:institutes, [
      stub_model(Institute),
      stub_model(Institute)
    ])
  end

  it "renders a list of institutes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
