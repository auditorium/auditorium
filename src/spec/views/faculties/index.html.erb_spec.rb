require 'spec_helper'

describe "faculties/index" do
  before(:each) do
    assign(:faculties, [
      stub_model(Faculty),
      stub_model(Faculty)
    ])
  end

  it "renders a list of faculties" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
