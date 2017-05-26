FactoryGirl.define do
  factory :wikipedia_event do
    association       :wikipedia_date
    permalink         { Faker::Hipster.words(3).join('_') }
    page_url          { Faker::Internet.url('en.wikipedia.org/wiki') }
    title             { Faker::Hipster.sentence }
    summary           { Faker::Hipster.paragraph }
    image_url         { Faker::Internet.url('upload.wikimedia.org') }
    last_edited_at    { 1.day.ago }
    created_at        { 1.day.ago }
    updated_at        { 1.day.ago }
  end
end