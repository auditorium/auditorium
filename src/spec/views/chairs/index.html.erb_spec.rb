require 'spec_helper'

describe "chairs/index" do
  before(:each) do
    assign(:chairs, [
      stub_model(Chair),
      stub_model(Chair)
    ])
  end

  it "renders a list of chairs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
