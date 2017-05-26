require 'rails_helper'

RSpec.describe WikipediaService, vcr: true do
  
  describe '#initialize' do
    subject { described_class.new(permalink) }
    let(:permalink) { 'foobar' }

    it 'should set instance variables' do
      expect(subject.permalink).to be(permalink)
      expect(subject.wikipedia_date).to be_nil
      expect(subject.wikipedia_events).to eq([])
    end
  end
  
  describe '#find_or_create' do
    let(:service) { described_class.new(permalink) }
    subject { service.find_or_create }

    def prehook
    end

    before do
      prehook
      subject
    end

    context 'events exist' do
      let(:permalink) { '2001_January_1' }
      let(:wikipedia_date) { FactoryGirl.create(:wikipedia_date, :with_three_events, permalink: permalink) }

      def prehook
        wikipedia_date
      end

      it 'should return the events' do
        expect(subject).to be_an(ActiveRecord::Associations::CollectionProxy)
        expect(subject.length).to be 3
        expect(subject.map(&:id)).to match_array(wikipedia_date.events.map(&:id))
      end
    end

    context 'events do not exist' do
      let(:permalink) { '2017_May_21' }

      it 'should return the events' do
        expect(subject).to be_an(ActiveRecord::Associations::CollectionProxy)
        expect(subject.length).to be 12
      end
    end

  end
end