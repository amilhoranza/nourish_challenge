require 'rails_helper'

RSpec.describe Appointment, type: :model do

  let(:appointment) { build(:appointment) }

  it { is_expected.to validate_presence_of(:when) }

  it { is_expected.to validate_presence_of(:note) }

  it { is_expected.to validate_presence_of(:status) }

  it { is_expected.to validate_presence_of(:manually_edited) }

  it { is_expected.to respond_to(:when) }

  it { is_expected.to respond_to(:note) }

  it { is_expected.to respond_to(:status) }

  it { is_expected.to respond_to(:manually_edited) }

  it { is_expected.to belong_to(:schedule) }

  context "when is before the current time" do
    it {should_not allow_value(1.day.ago).for(:when)}
  end

end
