require 'spec_helper'

describe Event do
  # associations 
  it { should have_many(:periods) }

  %w{course tutor}.each do |assoc|
    it { should belong_to(assoc.to_sym) }
  end

  # validations
  %w{lecture exercise seminar lab}.each do |type|
    it { should allow_value(type).for(:event_type) }
  end
  it { should_not allow_value('other').for(:event_type) }
  %w{event_type course tutor}.each do |attr|
    it { should validate_presence_of(attr.to_sym) }
  end
end
