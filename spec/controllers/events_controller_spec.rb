require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  
  describe '#index' do
    context 'should respond and render successfully' do
      it 'with the proper status and format' do
        get :index
        expect(response.status).to be 200
        expect(response.content_type).to eq("text/html")
        expect(response).to have_rendered('events/index')
      end
    end
  end

end