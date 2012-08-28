require 'spec_helper'

describe "terms/show" do
  before(:each) do
    @term = assign(:term, stub_model(Term))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
