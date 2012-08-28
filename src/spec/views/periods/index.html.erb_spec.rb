require 'spec_helper'

describe "periods/index" do
  before(:each) do
    assign(:periods, [
      stub_model(Period),
      stub_model(Period)
    ])
  end

  it "renders a list of periods" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
