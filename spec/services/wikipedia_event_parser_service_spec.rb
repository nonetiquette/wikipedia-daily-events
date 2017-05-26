require 'rails_helper'

RSpec.describe WikipediaEventParserService, vcr: true do
  
  describe '#initialize' do
    subject { described_class.new(url) }

    context 'url is valid' do
      let(:url) { "#{::WikipediaEvent::BASE_URL}Heisenbug" }
      
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
      let(:url) { "#{::WikipediaEvent::BASE_URL}foobarbarbar" }

      it 'should raise error' do
        expect{subject}.to raise_error(::ExternalPageNotFoundError)
      end
    end
    
  end
  
  describe '#parse' do
    subject { described_class.new(url).parse }

    context 'url is valid' do
      let(:url) { "#{::WikipediaEvent::BASE_URL}Heisenbug" }

      it 'should parse and return a hash of info' do
        expect(subject.except(:last_edited_at)).to eq(
          {
                :permalink => "Heisenbug",
                  :page_url => "https://en.wikipedia.org/wiki/Heisenbug",
                    :title => "Heisenbug",
                :image_url => "//upload.wikimedia.org/wikipedia/en/thumb/9/99/Question_book-new.svg/50px-Question_book-new.svg.png",
                  :summary => "In computer programming jargon, a heisenbug is a software bug that seems to disappear or alter its behavior when one attempts to study it.[1] The term is a pun on the name of Werner Heisenberg, the physicist who first asserted the observer effect of quantum mechanics, which states that the act of observing a system inevitably alters its state. In electronics the traditional term is probe effect, where attaching a test probe to a device changes its behavior.Similar terms, such as bohrbug, mandelbug,[2][3][4] and schrödinbug[5][6] have been occasionally proposed for other kinds of unusual software bugs, sometimes in jest;[7][8] however, unlike the term \"heisenbug\", they are not widely known or used.[9][original research?]"
          }
        )
      end  
    end

    context 'url cannot be found' do
      let(:url) { "#{::WikipediaEvent::BASE_URL}foobarbarbar" }

      it 'should raise error' do
        expect{subject}.to raise_error(::ExternalPageNotFoundError)
      end
    end
    
  end

end