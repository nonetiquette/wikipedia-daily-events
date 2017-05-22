import wikipediaEventsController from './wikipedia_events.controller';
import dateRestrictionsConstant from './../constants/date_restrictions.constant';

let moduleName = 'WikipediaEventsModule';

angular.module(moduleName, [
  'ui.router',
  'ngSanitize',
  dateRestrictionsConstant
])
  .config(['$stateProvider', ($stateProvider) =>
    $stateProvider.state('events', {
      url: '/events/:occurrenceDatePermalink',
      template: '<wikipedia-events></wikipedia-events>'
    })
  ])
  .component('wikipediaEvents', {
    templateUrl: 'app/components/wikipedia_events/wikipedia_events.html',
    controller: wikipediaEventsController
  })
  .factory('WikipediaEventsService', railsResourceFactory => {
    return railsResourceFactory({
      url: '/api/v1/wikipedia_dates/{{occurrenceDatePermalink}}/wikipedia_events',
      name: 'wikipediaEvents'
    })
  });

export default moduleName;