require 'spec_helper'

describe "periods/show" do
  before(:each) do
    @period = assign(:period, stub_model(Period))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
