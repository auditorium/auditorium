require 'spec_helper'

describe CourseMembership do
  # associations
  %w{user course}.each do |assoc|
    it { should belong_to(assoc.to_sym) }
  end

  # validations
  %w{membership_type user course}.each do |attr|
    it { should validate_presence_of(attr.to_sym) }
  end
  it { should allow_value('maintainer').for(:membership_type) }
  it { should allow_value('editor').for(:membership_type) }
  it { should allow_value('member').for(:membership_type) }
  it { should_not allow_value('other').for(:membership_type) }
  it { should_not allow_mass_assignment_of(:membership_type) }
end
