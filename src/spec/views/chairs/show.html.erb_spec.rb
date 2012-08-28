require 'spec_helper'

describe "chairs/show" do
  before(:each) do
    @chair = assign(:chair, stub_model(Chair))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
