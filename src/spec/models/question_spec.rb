require 'spec_helper'

describe Question do 

  describe "create a new question" do
    let(:author) { create(:user) }
    let(:member) { create(:user) }
    let(:group) { create(:lecture_group) }

    before(:each) do
      group.followers << member
    end

    after(:each) do
      ActionMailer::Base.deliveries.clear
    end     
      
    it "should send a email notification to the group member with default email settings" do
      question = create(:question, group_id: group.id, author: author)
      ActionMailer::Base.deliveries.count.should eq(1)
      email = ActionMailer::Base.deliveries.first
      email.should deliver_to(member.email)
    end

    it "should  not send an email notification to the group member with the setting receive email notifications set to false" do
      member.setting = create(:setting, receive_email_notifications: false)
      question = create(:question, group_id: group.id, author: author)
      ActionMailer::Base.deliveries.count.should eq(0)
    end

    it "should send no email notification to the author" do
      group.followers << author
      question = create(:question, group_id: group.id, author: author)
      ActionMailer::Base.deliveries.count.should eq(1)
    end
  end
end