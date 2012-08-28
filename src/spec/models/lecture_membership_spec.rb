require 'spec_helper'

describe LectureMembership do
  # associations
  %w{user lecture}.each do |assoc|
    it { should belong_to(assoc.to_sym) }
  end
end
