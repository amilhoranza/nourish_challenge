require 'rails_helper'

RSpec.describe 'Schedule API' do
  before { host! 'api.nourishchallenge.test' }

  let!(:user) { create(:user) }
  let(:headers) do
    {
      'Content-Type' => Mime[:json].to_s,
      'Accept' => 'application/vnd.nourishchallenge.v1',
      'Authorization' => user.auth_token
    }
  end


  describe 'GET /schedules' do
    before do
      create_list(:schedule, 5, user_id: user.id)
      get '/schedules', params: {}, headers: headers
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns 5 schedules from database' do
      expect(json_body[:schedules].count).to eq(5)
    end
  end


  describe 'GET /schedules/:id' do
    let(:schedule) { create(:schedule, user_id: user.id) }

    before { get "/schedules/#{schedule.id}", params: {}, headers: headers }

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns the json for schedule' do
      expect(json_body[:note]).to eq(schedule.note)
    end
  end


  describe 'POST /schedules' do
    before do
      post '/schedules', params: { schedule: schedule_params }.to_json, headers: headers
    end

    context 'when the params are valid' do
      let(:schedule_params) { attributes_for(:schedule) }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'saves the schedule in the database' do
        expect( Schedule.find_by(note: schedule_params[:note]) ).not_to be_nil
      end

      it 'returns the json for created schedule' do
        expect(json_body[:note]).to eq(schedule_params[:note])
      end

      it 'assigns the created schedule to the current user' do
        expect(json_body[:user_id]).to eq(user.id)
      end
    end

    context 'when the params are invalid' do
      let(:schedule_params) { attributes_for(:schedule, note: ' ') }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'does not save the schedule in the database' do
        expect( Schedule.find_by(note: schedule_params[:note]) ).to be_nil
      end

      it 'returns the json error for note' do
        expect(json_body[:errors]).to have_key(:note)
      end
    end
  end


  describe 'PUT /schedules/:id' do
    let!(:schedule) { create(:schedule, user_id: user.id) }

    before do
      put "/schedules/#{schedule.id}", params: { schedule: schedule_params }.to_json, headers: headers
    end

    context 'when the params are valid' do
      let(:schedule_params){ { note: 'New schedule note' } }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the json for updated schedule' do
        expect(json_body[:note]).to eq(schedule_params[:note])
      end

      it 'updates the schedule in the database' do
        expect( Schedule.find_by(note: schedule_params[:note]) ).not_to be_nil
      end
    end

    context 'when the params are invalid' do
      let(:schedule_params){ { note: ' '} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns the json error for note' do
        expect(json_body[:errors]).to have_key(:note)
      end

      it 'does not update the schedule in the database' do
        expect( Schedule.find_by(note: schedule_params[:note]) ).to be_nil
      end
    end
  end


  describe 'DELETE /schedules/:id' do
    let!(:schedule) { create(:schedule, user_id: user.id) }

    before do
      delete "/schedules/#{schedule.id}", params: {}, headers: headers
    end

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the schedule from the database' do
      expect { Schedule.find(schedule.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

end
