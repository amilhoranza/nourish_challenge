class Api::V1::AppointmentsController < Api::V1::BaseController

  before_action :authenticate_with_token!

  def index
    appointments = Appointment.where(schedule_id: current_user.schedules.ids)
    render json: { appointments: appointments }, status: 200
  end

  def show
    appointment = Appointment.find(params[:id])
    render json: appointment, status: 200
  end

  def create
    appointment = Appointment.new(appointment_params)

    if appointment.save
      render json: appointment, status: 201
    else
      render json: { errors: appointment.errors }, status: 422
    end
  end

  def update
    appointment = Appointment.find(params[:id])

    if appointment.update_attributes(appointment_params)
      render json: appointment, status: 200
    else
      render json: { errors: appointment.errors }, status: 422
    end
  end

  def destroy
    appointment = Appointment.find(params[:id])
    appointment.destroy
    head 204
  end


  private

  def appointment_params
    params.require(:appointment).permit(:when, :note, :schedule_id)
  end

end
