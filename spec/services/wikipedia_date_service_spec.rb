require 'rails_helper'

RSpec.describe WikipediaDateService do
  
  describe '#initialize' do
    subject { described_class.new(permalink) }
    let(:permalink) { '2001_January_1' }

    it 'should set instance variables' do
      expect(subject.permalink).to be(permalink)
    end
  end
  
  describe '#find_or_create' do
    let(:service) { described_class.new(permalink) }
    subject { service.find_or_create }
    let(:wikipedia_date_count) { ::WikipediaDate.count }

    def prehook
    end

    before do
      prehook
      subject
    end

    context 'date exist' do
      let(:permalink) { '2001_January_1' }
      let(:wikipedia_date) { FactoryGirl.create(:wikipedia_date, permalink: permalink) }

      def prehook
        wikipedia_date
        wikipedia_date_count
      end

      it 'should not create a date' do
        expect(::WikipediaDate.count).to eq(wikipedia_date_count)
      end

      it 'should return the date' do
        expect(subject.id).to eq(wikipedia_date.id)
      end
    end

    context 'date does not exist' do
      let(:permalink) { '2017_May_21' }

      def prehook
        wikipedia_date_count
      end

      it 'should create a date' do
        expect(::WikipediaDate.count).to eq(wikipedia_date_count + 1)
      end

      it 'should return the date' do
        expect(subject.id).to eq(::WikipediaDate.where(permalink: permalink).first.id)
      end
    end

  end
end