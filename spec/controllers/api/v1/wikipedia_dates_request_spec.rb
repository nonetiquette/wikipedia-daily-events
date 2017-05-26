require 'rails_helper'

RSpec.describe 'REQUEST /api/v1/wikipedia_dates', type: :request do
  
  describe '#index' do
    subject { get '/api/v1/wikipedia_dates' }
    let(:response_json) { JSON.parse(response.body).with_indifferent_access }

    def prehook
    end

    before do
      prehook
      subject
    end

    after do
      Rails.cache.clear
    end
    
    context 'should render successfully' do
      it 'with the proper status and format' do
        expect(response.status).to be 200
        expect(response.content_type).to eq("application/json")
      end
    end
    
    context 'records not found' do
      it 'should have proper response' do
        expect(response_json.keys).to match_array(['data','total_records'])
        expect(response_json).to include_json({
          data: [],
          total_records: 0
        })
      end
    end
    
    context 'records found' do
      let(:wikipedia_date) { FactoryGirl.create(:wikipedia_date) }
      let(:serialized_wikipedia_date) { WikipediaDateSerializer.new(wikipedia_date).as_json }

      def prehook 
        wikipedia_date
        serialized_wikipedia_date
      end

      it 'should have proper response' do
        expect(response_json.keys).to match_array(['data','total_records'])
        expect(response_json['total_records']).to be 1
        expect(response_json['data'].length).to be 1
        expect(response_json['data'][0].keys).to match_array(['id', 'permalink', 'page_url', 'occurred_on'])
        expect(response_json['data'][0].except('occurred_on')).to include_json(serialized_wikipedia_date.except(:occurred_on))
        expect(response_json['data'][0]['occurred_on'].to_date).to eq(wikipedia_date.occurred_on)
      end
    end
  end

  describe '#show' do
    let(:prehook) {}
    let(:permalink) {}
    let(:response_json) { JSON.parse(response.body) }
    let(:wikipedia_date) { }
    let(:service_double) { double('wikipedia_date_service') }

    def setup_service_stub
      allow(::WikipediaDateService).to receive(:new).with(permalink).and_return(service_double)
      allow(service_double).to receive(:find_or_create).and_return(wikipedia_date)
    end

    subject { get "/api/v1/wikipedia_dates/#{permalink}" }

    before :each do
      prehook
      setup_service_stub
      subject
    end
    
    context 'record found' do
      let(:wikipedia_date) { FactoryGirl.create(:wikipedia_date) }
      let(:serialized_wikipedia_date) { WikipediaDateSerializer.new(wikipedia_date).as_json }
      let(:permalink) { wikipedia_date.permalink }
      let(:prehook) { wikipedia_date }

      it 'should respond successfully with the proper status and format' do
        expect(response.status).to be 200
        expect(response.content_type).to eq("application/json")
      end

      it 'should have proper response' do
        expect(response_json.keys).to match_array(['id', 'permalink', 'page_url', 'occurred_on'])
        expect(response_json.except('occurred_on')).to include_json(serialized_wikipedia_date.except(:occurred_on))
        expect(response_json['occurred_on'].to_date).to eq(wikipedia_date.occurred_on)
      end
    end

    context 'invalid permalink' do
      let(:permalink) { 'foobar' }

      it 'should respond unsuccessfully with the proper status and format' do
        expect(response.status).to be 422
        expect(response.content_type).to eq("application/json")
      end
    end

    context 'record not found' do
      let(:wikipedia_date) { FactoryGirl.create(:wikipedia_date) }
      let(:serialized_wikipedia_date) { WikipediaDateSerializer.new(wikipedia_date).as_json }
      let(:permalink) { FactoryGirl.attributes_for(:wikipedia_date)[:permalink] }

      it 'should respond successfully with the proper status and format' do
        expect(response.status).to be 200
        expect(response.content_type).to eq("application/json")
      end

      it 'should have proper response' do
        expect(response_json.keys).to match_array(['id', 'permalink', 'page_url', 'occurred_on'])
        expect(response_json.except('occurred_on')).to include_json(serialized_wikipedia_date.except(:occurred_on))
        expect(response_json['occurred_on'].to_date).to eq(wikipedia_date.occurred_on)
      end
    end
    
  end

end