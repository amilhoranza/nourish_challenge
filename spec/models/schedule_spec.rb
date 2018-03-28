require 'rails_helper'

RSpec.describe Schedule, type: :model do

  let(:schedule) { build(:schedule) }

  it { is_expected.to validate_presence_of(:starting_on) }

  it { is_expected.to validate_presence_of(:ending_on) }

  it { is_expected.to validate_presence_of(:note) }

  it { is_expected.to validate_numericality_of(:interval)  }

  it { is_expected.to respond_to(:starting_on) }

  it { is_expected.to respond_to(:ending_on) }

  it { is_expected.to respond_to(:note) }

  it { is_expected.to respond_to(:interval) }

  it { is_expected.to belong_to(:user) }

  context "when start_date is before the current time" do
    it {should_not allow_value(1.day.ago).for(:starting_on)}
  end

  context "when end_date is before or on start date" do
    it {should_not allow_value(schedule.starting_on - 1.day).for(:ending_on)}

    it {should_not allow_value(schedule.starting_on).for(:ending_on)}
  end

  context "when interval is not an number" do
    it {should_not allow_value('abb').for(:interval)}
  end


end
