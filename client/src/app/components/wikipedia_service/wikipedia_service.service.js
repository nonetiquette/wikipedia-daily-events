class WikipediaService {
  constructor(railsResourceFactory){
    return railsResourceFactory({
      url: '/api/v1/wikipedia_dates',
      name: 'wikipedia_dates'
    });
  }

  query() {
    return this.resource.query();
  }
}

WikipediaService.$inject = ['railsResourceFactory'];

export default WikipediaService;