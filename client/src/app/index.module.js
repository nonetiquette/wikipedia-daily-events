import { config } from './index.config';
import { routerConfig } from './index.route';
import { runBlock } from './index.run';
import navbarModule from '../app/components/navbar/navbar.module';
import wikipediaDatesModule from '../app/components/wikipedia_dates/wikipedia_dates.module';
import wikipediaEventsModule from '../app/components/wikipedia_events/wikipedia_events.module';

let moduleName = 'wikipediaDailyEvents';

angular.module(moduleName, [
  'ngAnimate',
  'ngSanitize',
  'ngCookies',
  'ngTouch',
  'ngAria',
  'ngResource',
  'ui.router',
  'ui.bootstrap',
  'toastr',
  'rails',
  navbarModule,
  wikipediaDatesModule,
  wikipediaEventsModule
])
  .config(config)
  .config(routerConfig)
  .run(runBlock);

export default moduleName;