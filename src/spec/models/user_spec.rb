require 'spec_helper'

describe User do
  before(:each) do
    FactoryGirl.create(:user)
  end

  # associations
  %w{events courses course_memberships}.each do |assoc|
    it { should have_many(assoc.to_sym) }
  end

  # validations
  %w{password email}.each do |attr|
    it { should validate_presence_of(attr.to_sym) }
  end

  it { should_not allow_value('abcd').for(:email) }
  it { should_not allow_value('abcd@cd').for(:email) }
  it { should allow_value('abcd@efgh.com').for(:email) }
end
