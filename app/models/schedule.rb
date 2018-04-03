require "recurrence"

class Schedule < ApplicationRecord
  belongs_to :user
  has_many :appointments, autosave: true

  validates_presence_of :starting_on, :ending_on, :note
  validates :interval, :numericality => true
  validates_date :starting_on,
    :after => (DateTime.now - 1.day),
    :after_message => "Start time cannot start in the past"
  validates_date :ending_on,
    :after => :starting_on,
    :after_message => "End time cannot be before start time"


  after_create :create_appointments
  after_update :update_appointments, :if => :has_changed?
  after_destroy :cleanup

  private

  def create_appointments
    # Saving appointments for this schedule
    recurrencies = Recurrence.new(:every => :day, :starts => starting_on, :until => ending_on, :interval => interval)
    recurrencies.events.each do |date|
      Appointment.create(schedule_id: id, when: "#{date} #{starting_on.strftime('%T')}", note: note)
    end
  end

  def update_appointments
    cleanup
    create_appointments
  end

  def cleanup
    Appointment.where(schedule_id: id, status: 'planned', manually_edited: 'no').delete_all
  end

  def has_changed?
    self.changed?
  end

end
