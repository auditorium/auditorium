require 'spec_helper'

describe Lecture do
  it { should have_many(:courses) }

  it { should belong_to(:chair) }

  %w{name chair}.each do |attr|
    it { should validate_presence_of(attr.to_sym) }
  end
end
