describe('WikipediaEventsController', () => {
  let controller,
      q,
      response,
      wikipediaEventsService;
  
  beforeEach(angular.mock.module('wikipediaDailyEvents'));
  
  beforeEach(() => {
    response = [  
      {  
          "id":275,
          "wikipedia_date_id":39,
          "permalink":"%C5%BDeljko_Ra%C5%BEnatovi%C4%87",
          "page_url":"https://en.wikipedia.org/wiki/%C5%BDeljko_Ra%C5%BEnatovi%C4%87",
          "title":"Arkan",
          "summary":"Željko Ražnatović (Serbian Cyrillic: Жељко Ражнатовић, pronounced [ʐêːʎko raʐnâːtoʋit͡ɕ]; 17 April 1952 – 15 January 2000), better known as Arkan (Аркан), was a Serbian career criminal and commander of a paramilitary force in the Yugoslav Wars, called the Serb Volunteer Guard. He was on Interpol's most wanted list in the 1970s and 1980s for robberies and murders committed in a number of countries across Europe, and was later indicted by the UN for crimes against humanity for his role during the wars. Ražnatović was up until his death the most powerful crime boss in the Balkans. He was assassinated in 2000, before his trial could take place.",
          "image_url":"//upload.wikimedia.org/wikipedia/en/thumb/a/a3/%C5%BDeljko_Ra%C5%BEnatovi%C4%87.jpg/220px-%C5%BDeljko_Ra%C5%BEnatovi%C4%87.jpg",
          "last_edited_at":"2017-05-09T15:55:00.000Z"
      }
    ];

    inject(($componentController, $q, WikipediaEventsService) => {
      controller = $componentController('wikipediaEvents');
      q = $q;
      wikipediaEventsService = WikipediaEventsService;
    })
  });

  describe('constructor', () => {
    it('should instantiate some starting variables', () => {
      expect(controller.isLoading).not.toBe(null);
      expect(controller.occurrenceDatePermalink).not.toBe(null);
      expect(controller.occurrenceDate).not.toBe(null);
    });
  });

  describe('validateDate', () => {
    describe('valid date, within date range', () => {
      it('should be true', () => {
        let date = moment('1/2/2000', 'MM/DD/YYYY');
        let minDate = moment('1/1/2000', 'MM/DD/YYYY');
        let maxDate = moment('1/3/2000', 'MM/DD/YYYY');
        expect(controller.validateDate(date, minDate, maxDate)).toBe(true);
      });
    });

    describe('valid date, not within date range', () => {
      it('should be false', () => {
        let date = moment('1/1/2000', 'MM/DD/YYYY');
        let minDate = moment('1/2/2000', 'MM/DD/YYYY');
        let maxDate = moment('1/3/2000', 'MM/DD/YYYY');
        expect(controller.validateDate(date, minDate, maxDate)).toBe(false);
      });
    });

    describe('invalid date', () => {
      it('should be false', () => {
        let date = moment('foobar', 'MM/DD/YYYY');
        let minDate = moment('1/1/2000', 'MM/DD/YYYY');
        let maxDate = moment('1/3/2000', 'MM/DD/YYYY');
        expect(controller.validateDate(date, minDate, maxDate)).toBe(false);
      });
    });
  });

  describe('getEvents', () => {
    it('should call WikipediaEventsService', () => {
      let permalink = '2001_January_1';
      spyOn(wikipediaEventsService, 'query').and.returnValue(q((resolve) => {
        resolve(response);
      }));
      controller.getEvents(permalink);
      expect(wikipediaEventsService.query).toHaveBeenCalled;
      expect(controller.events).not.toBe(null);
    });
  });

  describe('validateFormat', () => {
    describe('matches the regex', () => {
      it('should be true', () => {
        let datePermalink = '2001_January_10';
        let permalinkFormat = new RegExp(/^\d{4}_\w{3,9}_\d{1,2}$/);
        expect(controller.validateFormat(datePermalink, permalinkFormat)).toBe(true);
      });
    });

    describe('does not match the regex', () => {
      it('should be false', () => {
        let datePermalink = 'January_10_2001';
        let permalinkFormat = new RegExp(/^\d{4}_\w{3,9}_\d{1,2}$/);
        expect(controller.validateFormat(datePermalink, permalinkFormat)).toBe(false);
      });
    });
  });

  describe('sanitizeEvent', () => {
    it('should sanitize some html', () => {
      let event = {
        title: 'foobar<em onmouseover="this.textContent=\'PWN3D!\'">click here</em>',
        pageUrl: 'foobar<em onmouseover="this.textContent=\'PWN3D!\'">click here</em>',
        imageUrl: 'foobar<em onmouseover="this.textContent=\'PWN3D!\'">click here</em>',
        summary: 'foobar<em onmouseover="this.textContent=\'PWN3D!\'">click here</em>',
        lastEditedAt: new Date(2000,1,1,12,0)
      };
      let sanitizedOutput = {
        title: 'foobar',
        pageUrl: 'foobar',
        imageUrl: 'foobar',
        summary: 'foobar',
        lastEditedAt: '2/1/00 12:00 AM'
      };
      expect(controller.sanitizeEvent(event)).not.toBe(sanitizedOutput);
    });
  });
});
