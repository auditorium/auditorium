require 'spec_helper'

describe Group do 

  it "is valid with a title, description and group type and a user as creator" do
    group = build(:lecture_group)
    expect(group).to be_valid
  end
  
  it "is invalid without a title" do
    group = build(:topic_group, title: nil)
    expect(group).to have(1).errors_on(:title)
  end
  
  it "is invalid without a description" do
    group = build(:learning_group, description: nil)
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

  it "is invalid with group_type other than 'learning', 'lecture', 'topic'" do
    group = build(:group, group_type: 'invalid_type')
    expect(group).to have(1).errors_on(:group_type)
  end

  it { should have_many(:announcements).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:topics).dependent(:destroy) }

  it { should belong_to(:creator) }
  it { should have_many(:tags) }
end