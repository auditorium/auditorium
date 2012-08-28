require 'spec_helper'

describe Faculty do
  # associations
  it { should have_many(:institutes) }
  it { should validate_presence_of(:name) }
end
