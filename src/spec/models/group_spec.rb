# == Schema Information
#
# Table name: groups
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  group_type    :string(255)
#  creator_id    :integer          default(1)
#  private_posts :boolean
#  url           :string(255)
#  approved      :boolean
#  deactivated   :boolean          default(FALSE)
#

require 'spec_helper'

describe Group do 
  it "has 3 followers" do
    group = create(:group_with_three_followers)
    group.followers.count.should eq(3)
  end

  it "has the creator as moderator" do
    group = create(:lecture_group)
    group.followers.should include(group.creator)
  end

  it "is valid with a title, description and group type and a user as creator" do
    group = build(:lecture_group)
    expect(group).to be_valid
  end
  
  it "is invalid without a title" do
    group = build(:topic_group, title: nil)
    expect(group).to have(1).errors_on(:title)
  end
  
  it "is invalid without a description" do
    group = build(:study_group, description: nil)
    expect(group).to have(1).errors_on(:description)
  end

  it "is invalid without a group type" do
    group = build(:group, group_type: nil)
    expect(group).to have(2).errors_on(:group_type) # 2 errors because of the inclusion validation
  end

  it "is invalid without a creator" do
    group = build(:group)
    group.creator = nil
    expect(group).to have(1).errors_on(:creator_id)
  end

  it "is invalid with group_type other than 'study', 'lecture', 'topic'" do
    group = build(:group, group_type: 'invalid_type')
    expect(group).to have(1).errors_on(:group_type)
  end

  it { should have_many(:announcements).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:topics).dependent(:destroy) }

  it { should belong_to(:creator) }
  it { should have_many(:tags) }
end
