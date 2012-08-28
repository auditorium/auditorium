require 'spec_helper'

describe "periods/new" do
  before(:each) do
    assign(:period, stub_model(Period).as_new_record)
  end

  it "renders new period form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => periods_path, :method => "post" do
    end
  end
end
