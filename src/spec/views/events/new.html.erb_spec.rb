require 'spec_helper'

describe "events/new" do
  before(:each) do
    assign(:event, stub_model(Event).as_new_record)
  end

  it "renders new event form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => events_path, :method => "post" do
    end
  end
end
