require 'spec_helper'

describe Post do
  before(:each) do
    #FactoryGirl.create(:question)
  end

  # assocs
  it { should have_many(:children).class_name('Post') }
  it { should have_one(:answer).class_name('Post') }

  it { should belong_to(:parent).class_name('Post') }
  it { should belong_to(:answer_to).class_name('Post') }
  it { should belong_to(:course) }

  # presence
  %w{post_type subject course}.each do |attr|
    it { should validate_presence_of(attr.to_sym) }
  end

  %w{question answer info}.each do |type|
    it { should allow_value(type).for(:post_type) }
  end
  it { should_not allow_value('other').for(:post_type) }
end
