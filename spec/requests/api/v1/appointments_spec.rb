require 'rails_helper'

RSpec.describe 'Appouintment API' do
  before { host! 'api.nourishchallenge.test' }

  let!(:user) { create(:user) }
  let!(:schedule) { create(:schedule) }
  let(:headers) do
    {
      'Content-Type' => Mime[:json].to_s,
      'Accept' => 'application/vnd.nourishchallenge.v1',
      'Authorization' => user.auth_token
    }
  end


  describe 'GET /appointments' do
    before do
      create_list(:appointment, 5, schedule_id: schedule.id)
      get '/appointments', params: {}, headers: headers
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

  end


  describe 'GET /appointments/:id' do
    let(:appointment) { create(:appointment, schedule_id: schedule.id) }

    before { get "/appointments/#{appointment.id}", params: {}, headers: headers }

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns the json for appointment' do
      expect(json_body[:note]).to eq(appointment.note)
    end
  end


  describe 'PUT /appointments/:id' do
    let!(:appointment) { create(:appointment, schedule_id: schedule.id) }

    before do
      put "/appointments/#{appointment.id}", params: { appointment: appointment_params }.to_json, headers: headers
    end

    context 'when the params are valid' do
      let(:appointment_params){ { note: 'New appointment note' } }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the json for updated appointment' do
        expect(json_body[:note]).to eq(appointment_params[:note])
      end

      it 'updates the appointment in the database' do
        expect( Appointment.find_by(note: appointment_params[:note]) ).not_to be_nil
      end
    end

    context 'when the params are invalid' do
      let(:appointment_params){ { note: ' '} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns the json error for note' do
        expect(json_body[:errors]).to have_key(:note)
      end

      it 'does not update the appointment in the database' do
        expect( Appointment.find_by(note: appointment_params[:note]) ).to be_nil
      end
    end
  end


  describe 'DELETE /appointments/:id' do
    let!(:appointment) { create(:appointment, schedule_id: schedule.id) }

    before do
      delete "/appointments/#{appointment.id}", params: {}, headers: headers
    end

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the appointment from the database' do
      expect { Appointment.find(appointment.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

end
