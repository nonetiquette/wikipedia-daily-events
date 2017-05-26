class WikipediaDate::OccurredOnValidator < ActiveModel::Validator

  def validate(wikipedia_date)
    if !wikipedia_date.occurred_on.is_a?(Date)
      wikipedia_date.errors.add :occurred_on, 'is not a date'
    end

    if wikipedia_date.occurred_on.is_a?(Date) && wikipedia_date.occurred_on < WikipediaDate::MINIMUM_OCCURRED_ON_DATE
      wikipedia_date.errors.add :occurred_on, "must be after #{WikipediaDate::MINIMUM_OCCURRED_ON_DATE.strftime('%m/%d/%Y')}"
    end
  end
end
