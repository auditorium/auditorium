require 'spec_helper'

describe "institutes/show" do
  before(:each) do
    @institute = assign(:institute, stub_model(Institute))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
