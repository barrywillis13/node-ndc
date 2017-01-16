
var identify = (req, res, next) => {

  var reqString = req.body.toString();
  if(reqString.startsWith('<AirShoppingRQ', reqString.indexOf('<AirShoppingRQ'))){
      req.id = 'shop';
  } else if(reqString.startsWith('<AirDocCancelRQ', reqString.indexOf('<AirDocCancelRQ'))){
      req.id = 'cancelTicket';
  } else if(reqString.startsWith('<AirDocIssueRQ', reqString.indexOf('<AirDocIssueRQ'))){
      req.id = 'ticket';
  } else if(reqString.startsWith('<FareRulesRQ', reqString.indexOf('<FareRulesRQ'))){
      req.id = 'rules';
  } else if(reqString.startsWith('<FlightPriceRQ', reqString.indexOf('<FlightPriceRQ'))){
      req.id = 'airfare';
  } else if(reqString.startsWith('<OrderCancelRQ', reqString.indexOf('<OrderCancelRQ'))){
      req.id = 'cancel';
  } else if(reqString.startsWith('<OrderChangeRQ', reqString.indexOf('<OrderChangeRQ'))){
      req.id = 'modify';
  } else if(reqString.startsWith('<OrderViewRQ', reqString.indexOf('<OrderViewRQ'))){
      req.id = 'read';
  } else if(reqString.startsWith('<SeatAvailabilityRQ', reqString.indexOf('<SeatAvailabilityRQ'))){
      req.id = 'seatmap';
  } else if(reqString.startsWith('<OrderCreateRQ', reqString.indexOf('<OrderCreateRQ'))){
      req.id = 'book';
  }
  next();
}

module.exports = {identify}
