# == Schema Information
#
# Table name: announcements
#
#  id            :integer          not null, primary key
#  subject       :string(255)
#  content       :text
#  rating        :integer          default(0)
#  views         :integer
#  is_private    :boolean
#  author_id     :integer
#  group_id      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  last_activity :datetime
#


require 'spec_helper'

describe Announcement do
  describe "create a new announcement" do
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
      announcement = create(:announcement, group_id: group.id, author: author)
      ActionMailer::Base.deliveries.count.should eq(1)
      email = ActionMailer::Base.deliveries.first
      email.should deliver_to(member.email)
    end

    it "should  not send an email notification to the group member with the setting receive email notifications set to false" do
      ActionMailer::Base.deliveries.clear
      member.setting = create(:setting, receive_email_notifications: false)
      announcement = create(:announcement, group_id: group.id, author: author)
      ActionMailer::Base.deliveries.count.should eq(0)
    end

    it "should send no email notification to the author" do
      group.followers << author
      ActionMailer::Base.deliveries.clear
      announcement = create(:announcement, group_id: group.id, author: author)
      ActionMailer::Base.deliveries.count.should eq(1)
    end
  end
end
