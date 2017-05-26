require 'rails_helper'

RSpec.describe WikipediaDateParserService, vcr: true do
  
  describe '#initialize' do
    subject { described_class.new(url) }

    context 'url is valid' do
      let(:url) { "#{::WikipediaDate::BASE_URL}2001_January_1" }
      
      it 'should not raise error' do
        expect{subject}.not_to raise_error
      end

      it 'should successfully request page' do
        expect(subject.response).to be_a(Net::HTTPOK)
      end
    end

    context 'url is invalid' do
      let(:url) { 'http://www.foobar.com/foobar' }

      it 'should raise error' do
        expect{subject}.to raise_error(::ApiInvalidParametersError)
      end
    end

    context 'url cannot be found' do
      let(:url) { "#{::WikipediaDate::BASE_URL}2001_January_2" }

      it 'should raise error' do
        expect{subject}.to raise_error(::ExternalPageNotFoundError)
      end
    end
    
  end
  
  describe '#parse' do
    subject { described_class.new(url).parse }

    context 'url is valid' do
      let(:url) { "#{::WikipediaDate::BASE_URL}2001_January_1" }

      it 'should parse out an array of urls' do
        expect(subject).to match_array(["https://en.wikipedia.org/wiki/Israeli%E2%80%93Palestinian_conflict", "https://en.wikipedia.org/wiki/Seattle_Monolith", "https://en.wikipedia.org/wiki/2001:_A_Space_Odyssey_(film)", "https://en.wikipedia.org/wiki/Euro", "https://en.wikipedia.org/wiki/3rd_millennium"])
      end 
    end

    context 'url cannot be found' do
      let(:url) { "#{::WikipediaDate::BASE_URL}2001_January_2" }

      it 'should raise error' do
        expect{subject}.to raise_error(::ExternalPageNotFoundError)
      end
    end
    
  end

end