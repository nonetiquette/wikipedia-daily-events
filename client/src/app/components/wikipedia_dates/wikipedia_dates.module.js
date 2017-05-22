import wikipediaDatesController from './wikipedia_dates.controller';
import dateRestrictionsConstant from './../constants/date_restrictions.constant';

let moduleName = 'WikipediaDatesModule';

angular.module(moduleName, [
  'ui.router',
  dateRestrictionsConstant
])
  .config(['$stateProvider', ($stateProvider) =>
    $stateProvider.state('dates', {
      url: '/',
      template: '<wikipedia-dates></wikipedia-dates>'
    })
  ])
  .component('wikipediaDates', {
    templateUrl: 'app/components/wikipedia_dates/wikipedia_dates.html',
    controller: wikipediaDatesController
  })
  .factory('WikipediaDatesService', railsResourceFactory => {
    return railsResourceFactory({
      url: '/api/v1/wikipedia_dates',
      name: 'wikipedia_dates'
    })
  });

export default moduleName;