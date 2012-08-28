require 'spec_helper'

describe Institute do
  # associations
  it { should have_many(:chairs) }
  it { should belong_to(:faculty) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:faculty) }
end
