require 'spec_helper'

describe Course do
  # associations
  %w{posts events course_memberships users}.each do |assoc|
    it { should have_many(assoc.to_sym) }
  end

  %w{lecture term}.each do |attr|
    it { should belong_to(attr.to_sym) }
  end
  %w{lecture term name}.each do |attr|
    it { should validate_presence_of(attr.to_sym) }
  end
end
