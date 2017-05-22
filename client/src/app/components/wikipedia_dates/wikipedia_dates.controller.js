export default class WikipediaDatesController
{
  constructor ($scope, WikipediaDatesService, dateRestrictions, $state) {
    'ngInject';
    this.$scope = $scope;
    this.$state = $state;
    this.WikipediaDatesService = WikipediaDatesService;
    this.dateRestrictions = dateRestrictions;

    this.dates = [];
    this.selectedDate = moment();
    this.dateOptions = {
      showWeeks: false,
      minDate: dateRestrictions.minDate,
      maxDate: dateRestrictions.maxDate
    };
    this.pagination = {
      maxSize: 10,
      currentPage: 1
    }

    this.getDates(this.pagination.currentPage);
  }

  onPageChange(pageNumber) {
    this.getDates(pageNumber);
  };

  getDates(pageNumber){
    this.WikipediaDatesService.query({page: pageNumber}).then(
      (wikipediaDates) => {
        angular.copy(wikipediaDates.data, this.$scope.$ctrl.dates);
        this.$scope.$ctrl.pagination.totalItems = wikipediaDates.totalRecords;
      },
      (error) => {
        this.$scope.$ctrl.error = error.statusText;
    });
  }

  onDateChange(newDate){
    let formattedDate = moment(newDate).format(this.dateRestrictions.permalinkDateFormat);
    this.$state.go('events', {occurrenceDatePermalink: formattedDate});
  }
}
