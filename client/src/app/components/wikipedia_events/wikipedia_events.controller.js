export default class WikipediaEventsController
{
  constructor ($scope, $stateParams, WikipediaEventsService, $sanitize, $filter, dateRestrictions) {
    'ngInject';
    this.$scope = $scope;
    this.$filter = $filter;
    this.$sanitize = $sanitize;
    this.WikipediaEventsService = WikipediaEventsService;

    this.isLoading = false;
    this.occurrenceDatePermalink = $stateParams.occurrenceDatePermalink;
    this.occurrenceDate = moment(this.occurrenceDatePermalink, dateRestrictions.permalinkDateFormat);

    let isValidDate = this.validateDate(this.occurrenceDate, dateRestrictions.minDate, dateRestrictions.maxDate);
    let isValidFormat = this.validateFormat(this.occurrenceDatePermalink, dateRestrictions.permalinkRegexFormat);

    if (isValidDate && isValidFormat) {
      this.getEvents(this.occurrenceDatePermalink);
    } else {
      this.error = 'Invalid Date';
    }
  }

  getEvents(occurrenceDatePermalink) {
    this.isLoading = true;
    this.WikipediaEventsService.get({occurrenceDatePermalink: occurrenceDatePermalink}).then(
      (wikipediaEvents) => {
        this.$scope.$ctrl.events = wikipediaEvents.map((event) => { return this.sanitizeEvent(event); });
        this.$scope.$ctrl.isLoading = false;
      },
      (error) => {
        this.$scope.$ctrl.error = error.statusText;
        this.$scope.$ctrl.isLoading = false;
      }
    );
  }

  validateDate(date, minDate, maxDate) {
    return !!(date.isValid() && date >= minDate && date <= maxDate)
  }

  validateFormat(datePermalink, permalinkFormat) {
    return permalinkFormat.test(datePermalink)
  }

  sanitizeEvent(event) {
    return {
      title: this.$sanitize(event.title),
      pageUrl: this.$sanitize(event.pageUrl),
      imageUrl: this.$sanitize(event.imageUrl),
      summary: this.$sanitize(event.summary),
      lastEditedAt: this.$filter('date')(event.lastEditedAt, 'short')
    };
  }
}
