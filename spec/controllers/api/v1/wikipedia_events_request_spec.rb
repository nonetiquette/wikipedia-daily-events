require 'rails_helper'

RSpec.describe 'REQUEST /api/v1/wikipedia_dates/:permalink/wikipedia_events', type: :request do
  
  describe '#index' do
    subject { get "/api/v1/wikipedia_dates/#{permalink}/wikipedia_events" }
    let(:response_json) { JSON.parse(response.body) }
    let(:service_double) { double('wikipedia_service') }
    let(:permalink) {}
    let(:wikipedia_events) {}
    
    def prehook
    end
      
    def setup_service_stubs
      allow(::WikipediaService).to receive(:new).with(permalink).and_return(service_double)
      allow(service_double).to receive(:find_or_create)
      allow(service_double).to receive(:wikipedia_events).and_return(wikipedia_events)
    end

    before do
      prehook
      setup_service_stubs
      subject
    end

    after do
      Rails.cache.clear
    end
    
    context 'records found' do
      let(:wikipedia_date) { FactoryGirl.create(:wikipedia_date, :with_three_events) }
      let(:wikipedia_events) { wikipedia_date.events }
      let(:serialized_wikipedia_events) { wikipedia_events.map{|event| WikipediaEventSerializer.new(event).as_json } }
      let(:permalink) { wikipedia_date.permalink }

      let(:prehook) do
        wikipedia_date
      end

      it 'should respond successfully with the proper status and format' do
        expect(response.status).to be 200
        expect(response.content_type).to eq("application/json")
      end

      it 'should have proper response' do
        expect(response_json).to be_an(Array)
        expect(response_json.length).to be 3
        expect(response_json.map{|x| x['id']}).to match_array(wikipedia_events.map(&:id))
        expect(response_json[0].keys).to match_array(['id', 'wikipedia_date_id', 'permalink', 'page_url', 'title', 'summary', 'image_url', 'last_edited_at'])
        expect(response_json[0].except('last_edited_at')).to include_json(serialized_wikipedia_events[0].except(:last_edited_at))
        expect(response_json[0]['last_edited_at'].to_datetime.to_i).to eq(wikipedia_events[0].last_edited_at.to_i)
      end
    end

    context 'records not found' do
      let(:wikipedia_date) { FactoryGirl.build(:wikipedia_date) }
      let(:wikipedia_event_urls) { 3.times.map{|x| Faker::Internet.url('en.wikipedia.org')} }
      let(:wikipedia_events) { wikipedia_event_urls.map{|url| FactoryGirl.build(:wikipedia_event, {wikipedia_date_id: wikipedia_date.id, page_url: url}) } }
      let(:serialized_wikipedia_events) { wikipedia_events.map{|event| WikipediaEventSerializer.new(event).as_json } }
      let(:permalink) { wikipedia_date.permalink }

      it 'should respond successfully with the proper status and format' do
        expect(response.status).to be 200
        expect(response.content_type).to eq("application/json")
      end

      it 'should have proper response' do
        expect(response_json).to be_an(Array)
        expect(response_json.length).to be 3
        expect(response_json.map{|x| x['id']}).to match_array(wikipedia_events.map(&:id))
        expect(response_json[0].keys).to match_array(['id', 'wikipedia_date_id', 'permalink', 'page_url', 'title', 'summary', 'image_url', 'last_edited_at'])
        expect(response_json[0].except('last_edited_at')).to include_json(serialized_wikipedia_events[0].except(:last_edited_at))
        expect(response_json[0]['last_edited_at'].to_datetime.to_i).to eq(wikipedia_events[0].last_edited_at.to_i)
      end
    end
  end

end