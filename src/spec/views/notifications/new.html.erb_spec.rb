require 'spec_helper'

describe "notifications/new" do
  before(:each) do
    assign(:notification, stub_model(Notification,
      :receivers => nil,
      :sender => nil
    ).as_new_record)
  end

  it "renders new notification form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => notifications_path, :method => "post" do
      assert_select "input#notification_receivers", :name => "notification[receivers]"
      assert_select "input#notification_sender", :name => "notification[sender]"
    end
  end
end
