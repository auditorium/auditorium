require 'spec_helper'

describe Comment do 

  describe "after create" do
    let(:author_of_parent_post) { create(:user) }
    let(:author_of_comment) { create(:user) }
    let(:member) { create(:user) }
    let(:group) { create(:lecture_group) }
    #let(:question) { create(:question, group_id: group.id, author: author_of_parent_post) }

    before(:each) do
      
    end

    it "should send email notification to group member with default email settings" do
      
      member.setting = create(:setting)
      author_of_parent_post.setting = create(:setting, receive_emails_when_author: false)
      group.followers << member
      group.followers.should include(member)
      question = create(:question, group_id: group.id, author: author_of_parent_post)
      ActionMailer::Base.deliveries.clear
      comment = create(:comment, commentable_id: question.id, commentable_type: 'Question', author: author_of_comment)
      ActionMailer::Base.deliveries.count.should eq(1)
      email = ActionMailer::Base.deliveries.first
      email.should deliver_to(member.email)
    end

    it "should not send notifications to group members who will not receive notifications" do
      author_of_parent_post.setting = create(:setting, receive_emails_when_author: false)
      question = create(:question, group_id: group.id, author: author_of_parent_post)
      ActionMailer::Base.deliveries.clear
      member.setting = create(:setting, receive_email_notifications: false)
      group.followers << member
      group.followers.should include(member)
      
      comment = create(:comment, commentable_id: question.id, commentable_type: 'Question', author: author_of_comment)
      ActionMailer::Base.deliveries.count.should eq(0)
    end

    it "should send notifications to non members but authors of a post in the thread with default email settings" do
      group.followers.should_not include(author_of_parent_post)
      author_of_parent_post.setting = create(:setting)
      question = create(:question, group_id: group.id, author: author_of_parent_post)
      ActionMailer::Base.deliveries.clear
      
      comment = create(:comment, commentable_id: question.id, commentable_type: 'Question', author: author_of_comment)
      ActionMailer::Base.deliveries.count.should eq(1)
      email = ActionMailer::Base.deliveries.first
      email.should deliver_to(author_of_parent_post.email)
    end

    it "should not send notifications to non members but authors of a post in the conversation who will not receive notifications when author" do
      group.followers.should_not include(author_of_parent_post)
      author_of_parent_post.setting = create(:setting, receive_emails_when_author: false)
      question = create(:question, group_id: group.id, author: author_of_parent_post)
      ActionMailer::Base.deliveries.clear
      
      comment = create(:comment, commentable_id: question.id, commentable_type: 'Question', author: author_of_comment)
      ActionMailer::Base.deliveries.count.should eq(0)
    end

    # it "should  not send an email notification to the group member with the setting receive email notifications set to false" do
    #   member.setting = create(:setting, receive_email_notifications: false)
    #   question = create(:question, group_id: group.id, author: author)
    #   ActionMailer::Base.deliveries.count.should eq(0)
    # end

    # it "should send no email notification to the author" do
    #   group.followers << author
    #   question = create(:question, group_id: group.id, author: author)
    #   ActionMailer::Base.deliveries.count.should eq(1)
    # end
  end
end