require 'spec_helper'

describe Term do
  # associations
  it { should have_many(:courses) }

  # validations
  %w{ss ws tri1 tri2 tri3}.each do |type|
    it { should allow_value(type).for(:term_type) }
  end
  it { should_not allow_value('other').for(:term_type) }
  %w{beginDate endDate term_type}.each do |attr|
    it { should validate_presence_of(attr.to_sym) }
  end
end
