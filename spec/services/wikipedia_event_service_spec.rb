require 'rails_helper'

RSpec.describe WikipediaEventService do
  
  describe '#initialize' do
    subject { described_class.new(wikipedia_date_id, permalink, attributes) }
    let(:wikipedia_date_id) { 1 }
    let(:permalink) { '2001_January_1' }
    let(:attributes) { {} }

    it 'should set instance variables' do
      expect(subject.wikipedia_date_id).to be(wikipedia_date_id)
      expect(subject.permalink).to be(permalink)
    end
  end
  
  describe '#find_or_create' do
    let(:service) { described_class.new(wikipedia_date_id, permalink, attributes) }
    subject { service.find_or_create }
    let(:wikipedia_event_count) { ::WikipediaEvent.count }

    def prehook
    end

    before do
      prehook
      subject
    end

    context 'event exists' do
      let(:wikipedia_date) { FactoryGirl.create(:wikipedia_date, :with_three_events) }
      let(:wikipedia_date_id) { wikipedia_date.id }
      let(:wikipedia_event) { wikipedia_date.events.first }
      let(:permalink) { wikipedia_event.permalink }
      let(:attributes) { {} }

      def prehook
        wikipedia_date
        wikipedia_event_count
      end

      it 'should not create an event' do
        expect(::WikipediaEvent.count).to eq(wikipedia_event_count)
      end

      it 'should return the event' do
        expect(subject.id).to eq(wikipedia_event.id)
      end
    end

    context 'event does not exist' do
      let(:wikipedia_date) { FactoryGirl.create(:wikipedia_date) }
      let(:wikipedia_date_id) { wikipedia_date.id }
      let(:permalink) { 'Software_testing' }
      let(:attributes) { FactoryGirl.attributes_for(:wikipedia_event, wikipedia_date_id: wikipedia_date_id) }

      def prehook
        wikipedia_event_count
        wikipedia_date
      end

      it 'should create an event' do
        expect(::WikipediaEvent.count).to eq(wikipedia_event_count + 1)
      end

      it 'should return the event' do
        expect(subject.id).to eq(::WikipediaEvent.where(permalink: permalink).first.id)
      end
    end

  end
end