FactoryGirl.define do
  factory :wikipedia_date do
    occurred_on { Faker::Date.between(WikipediaDate::MINIMUM_OCCURRED_ON_DATE, Date.today) }
    permalink   { WikipediaDateHelper.normalize_permalink(occurred_on.strftime(WikipediaDate::PERMALINK_DATE_FORMAT)) }
    page_url    { "#{WikipediaDate::BASE_URL}#{permalink}" }
    created_at  { 1.day.ago }
    updated_at  { 1.day.ago }

    trait :occurred_on_valid_random_date do
      occurred_on { Faker::Date.between(WikipediaDate::MINIMUM_OCCURRED_ON_DATE, Date.today) }
    end

    trait :occurred_on_valid do
      occurred_on { WikipediaDate::MINIMUM_OCCURRED_ON_DATE }
    end

    trait :occurred_on_invalid_before_date_range do
      occurred_on { WikipediaDate::MINIMUM_OCCURRED_ON_DATE - 1.day }
    end

    trait :occurred_on_invalid_after_date_range do
      occurred_on { Date.today + 1.day }
    end

    trait :with_three_events do
      after :create do |wikipedia_date|
        3.times do
          wikipedia_date.events << create(:wikipedia_event)
        end
        wikipedia_date.reload
      end
    end
  end

end