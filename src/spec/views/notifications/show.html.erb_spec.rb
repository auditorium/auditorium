require 'spec_helper'

describe "notifications/show" do
  before(:each) do
    @notification = assign(:notification, stub_model(Notification,
      :receivers => nil,
      :sender => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(//)
  end
end
