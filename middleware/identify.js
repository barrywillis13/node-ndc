
var identify = (req, res, next) => {
  var reqString = req.body.toString();
  var index = 0

  if (reqString.startsWith('<?xml version="1.0" encoding="UTF-8"?>')){
    index = 40
  } else if (reqString.startsWith('<?xml version="1.0" encoding="UTF-16"?>')){
    index = 41
  }
  if(reqString.startsWith('<AirShoppingRQ', reqString.indexOf('<AirShoppingRQ'))){
      req.id = 'shop';
  } else if(reqString.startsWith('<AirDocCancelRQ', index)){
      req.id = 'cancelTicket';
  } else if(reqString.startsWith('<AirDocIssueRQ', index)){
      req.id = 'ticket';
  } else if(reqString.startsWith('<FareRulesRQ', reqString.indexOf('<FareRulesRQ'))){
      req.id = 'rules';
  } else if(reqString.startsWith('<FlightPriceRQ', index)){
      req.id = 'airfare';
  } else if(reqString.startsWith('<OrderCancelRQ', index)){
      req.id = 'cancel';
  } else if(reqString.startsWith('<OrderChangeRQ', index)){
      req.id = 'modify';
  } else if(reqString.startsWith('<OrderViewRQ', index)){
      req.id = 'read';
  } else if(reqString.startsWith('<SeatAvailabilityRQ', index)){
      req.id = 'seatmap';
  }
  next();
}

module.exports = {identify}
