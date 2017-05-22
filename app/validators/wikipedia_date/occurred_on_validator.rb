class WikipediaDate::OccurredOnValidator < ActiveModel::Validator
  STARTING_DATE = Date.new(2000,1,1)

  def validate(wikipedia_date)
    if !wikipedia_date.occurred_on.is_a?(Date)
      wikipedia_date.errors.add :occurred_on, 'is not a date'
    end

    if wikipedia_date.occurred_on.is_a?(Date) && wikipedia_date.occurred_on < STARTING_DATE
      wikipedia_date.errors.add :occurred_on, "must be after #{STARTING_DATE.strftime('%m/%d/%Y')}"
    end
  end
end
