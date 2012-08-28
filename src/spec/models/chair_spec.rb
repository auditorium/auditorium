require 'spec_helper'

describe Chair do
  # associations
  it { should have_many(:lectures) }
  it { should belong_to(:institute) }

  # validations
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:institute) }
end
