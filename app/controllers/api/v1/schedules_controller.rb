require "recurrence"

class Api::V1::SchedulesController < Api::V1::BaseController

  before_action :authenticate_with_token!

  def index
    schedules = current_user.schedules
    render json: { schedules: schedules }, status: 200
  end

  def show
    schedule = current_user.schedules.find(params[:id])
    render json: schedule, status: 200
  end

  def create
    schedule = current_user.schedules.build(schedule_params)

    # Saving appointments for this schedule
    recurrencies = Recurrence.new(:every => :day, :starts => schedule.starting_on, :until => schedule.ending_on, :interval => schedule.interval)
    recurrencies.events.each do |date|
      schedule.appointments.build(schedule_id: schedule.id, when: "#{date} #{schedule.starting_on.strftime('%T')}", note: schedule.note)
    end


    if schedule.save
      render json: schedule, status: 201
    else
      render json: { errors: schedule.errors }, status: 422
    end
  end

  def update
    schedule = current_user.schedules.find(params[:id])

    if schedule.update_attributes(schedule_params)
      render json: schedule, status: 200
    else
      render json: { errors: schedule.errors }, status: 422
    end
  end

  def destroy
    schedule = current_user.schedules.find(params[:id])
    schedule.destroy
    head 204
  end


  private

  def schedule_params
    params.require(:schedule).permit(:starting_on, :ending_on, :note, :interval)
  end

end
