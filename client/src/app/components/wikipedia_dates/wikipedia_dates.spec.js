describe('WikipediaDatesController', () => {
  let controller,
      q,
      response,
      wikipediaDatesService,
      state;
  
  beforeEach(angular.mock.module('wikipediaDailyEvents'));
  
  beforeEach(() => {
    response = {  
        "data":[  
            {  
              "id":27,
              "permalink":"2001_January_1",
              "page_url":"https://en.wikipedia.org/wiki/Portal:Current_events/2001_January_1",
              "occurred_on":"2001-01-01"
            }
        ],
        "total_records":1
      };

    inject(($componentController, $q, WikipediaDatesService, $state) => {
      controller = $componentController('wikipediaDates');
      q = $q;
      wikipediaDatesService = WikipediaDatesService;
      state = $state;
    })
  });

  describe('constructor', () => {
    it('should instantiate some starting variables', () => {
      expect(controller.dates).not.toBe(null);
      expect(controller.selectedDate).not.toBe(null);
      expect(controller.dateOptions).not.toBe(null);
      expect(controller.pagination).not.toBe(null);
    });
  });

  describe('onPageChange', () => {
    it('should call getDates()', () => {
      let pageNumber = 2;
      spyOn(controller, 'getDates').and.callFake(()=> {
        return new q((resolve)=> { // eslint-disable-line new-cap
          resolve();
        });
      });
      controller.getDates(pageNumber);
      expect(controller.getDates).toHaveBeenCalledWith(pageNumber);
    });
  });

  describe('getDates', () => {
    it('should call WikipediaDatesService', () => {
      let pageNumber = 2;
      spyOn(wikipediaDatesService, 'query').and.returnValue(q((resolve) => {
        resolve(response);
      }));
      controller.getDates(pageNumber);
      expect(wikipediaDatesService.query).toHaveBeenCalledWith({ page: 2 });
    });
  });

  describe('onDateChange', () => {
    it('should go to another page', () => {
      let selectedDate = new Date(2001,1,1);
      spyOn(state, 'go');
      controller.onDateChange(selectedDate);
      expect(state.go).toHaveBeenCalledWith('events', {occurrenceDatePermalink: '2001_February_1'});
    });
  });
});
