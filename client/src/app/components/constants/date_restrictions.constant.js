let moduleName = 'dateRestrictions.constant';

angular.module(moduleName, [])
  .value('dateRestrictions', {
    minDate: moment("2000-01-01", "YYYY-MM-DD"),
    maxDate: moment(),
    permalinkDateFormat: 'YYYY_MMMM_D',
    permalinkRegexFormat: new RegExp(/^\d{4}_\w{3,9}_\d{1,2}$/)
  });

export default moduleName;
