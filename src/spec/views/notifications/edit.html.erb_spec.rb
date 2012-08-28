require 'spec_helper'

describe "notifications/edit" do
  before(:each) do
    @notification = assign(:notification, stub_model(Notification,
      :receivers => nil,
      :sender => nil
    ))
  end

  it "renders the edit notification form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => notifications_path(@notification), :method => "post" do
      assert_select "input#notification_receivers", :name => "notification[receivers]"
      assert_select "input#notification_sender", :name => "notification[sender]"
    end
  end
end
