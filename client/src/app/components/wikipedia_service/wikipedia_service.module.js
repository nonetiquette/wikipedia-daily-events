import WikipediaService from './wikipedia_service.service';

let moduleName = 'WikipediaService';

angular.module(moduleName, [])
  .service('wikipediaService', WikipediaService);

export default moduleName;
