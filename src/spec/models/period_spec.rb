require 'spec_helper'

describe Period do
  # associations
  it { should belong_to(:event) }

  # validations
  %w{duration weekday minute_of_day event}.each do |attr|
    it { should validate_presence_of(attr.to_sym) }
  end
  it { should ensure_inclusion_of(:minute_of_day).in_range(0..(60*24)) }

  %w{monday tuesday wednesday thursday friday saturday sunday}.each do |day|
    it { should allow_value(day).for(:weekday) }
  end
  it { should_not allow_value('other').for(:weekday) }

  it { should validate_numericality_of(:duration) }
  it { should validate_numericality_of(:minute_of_day) }
end
