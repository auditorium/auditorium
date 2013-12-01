# == Schema Information
#
# Table name: topics
#
#  id            :integer          not null, primary key
#  subject       :string(255)
#  content       :text
#  rating        :integer          default(0)
#  views         :integer
#  is_private    :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  group_id      :integer
#  author_id     :integer
#  last_activity :datetime
#

require 'spec_helper'

describe Topic do
  describe "create a new topic" do
    let(:author) { create(:user) }
    let(:member) { create(:user) }
    let(:group) { create(:lecture_group) }

    before(:each) do
      group
      group.followers = []
      group.followers << member
    end

    after(:each) do
      ActionMailer::Base.deliveries.clear
    end     
      
    it "should send a email notification to the group member with default email settings" do
      ActionMailer::Base.deliveries.clear
      topic = create(:topic, group_id: group.id, author: author)
      ActionMailer::Base.deliveries.count.should eq(1)
      email = ActionMailer::Base.deliveries.first
      email.should deliver_to(member.email)
    end

    it "should  not send an email notification to the group member with the setting receive email notifications set to false" do
      ActionMailer::Base.deliveries.clear
      member.setting = create(:setting, receive_email_notifications: false)
      topic = create(:topic, group_id: group.id, author: author)
      ActionMailer::Base.deliveries.count.should eq(0)
    end

    it "should send no email notification to the author" do
      group.followers << author
      topic = create(:topic, group_id: group.id, author: author)
      ActionMailer::Base.deliveries.count.should eq(1)
    end
  end
end
