require 'spec_helper'

describe "lectures/show" do
  before(:each) do
    @lecture = assign(:lecture, stub_model(Lecture))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
