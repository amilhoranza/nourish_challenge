require "recurrence"

class Schedule < ApplicationRecord
  belongs_to :user
  has_many :appointments

  validates_presence_of :starting_on, :ending_on, :note
  validates :interval, :numericality => true
  validates_date :starting_on,
    :after => (DateTime.now - 1.day),
    :after_message => "Start time cannot start in the past"
  validates_date :ending_on,
    :after => :starting_on,
    :after_message => "End time cannot be before start time"


  after_update :update_appointments
  after_destroy :cleanup

  private

  def update_appointments
    Appointment.where(schedule_id: id, status: 'planned', manually_edited: 'no').update_all(note: note)
  end

  def cleanup
    Appointment.where(schedule_id: id, status: 'planned', manually_edited: 'no').delete_all
  end

end
