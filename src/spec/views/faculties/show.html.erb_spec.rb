require 'spec_helper'

describe "faculties/show" do
  before(:each) do
    @faculty = assign(:faculty, stub_model(Faculty))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
