require 'spec_helper'

describe "terms/index" do
  before(:each) do
    assign(:terms, [
      stub_model(Term),
      stub_model(Term)
    ])
  end

  it "renders a list of terms" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
