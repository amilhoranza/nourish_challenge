class Appointment < ApplicationRecord
  enum status: [ :planned, :completed ]
  enum manually_edited: [ :no, :yes ]

  belongs_to :schedule

  validates_presence_of :when, :note, :status, :manually_edited

  validates_date :when,
    :after => (DateTime.now - 1.day),
    :after_message => "When cannot start in the past"


  before_update :has_been_edited_manually

  private

  def has_been_edited_manually
    self.manually_edited = 'yes'
  end

end
