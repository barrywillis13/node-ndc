const request = require('request')

var callApi = (xml, callback) => {
  var response;
  request({
      url: "https://sws.qa.sita.aero/hal_superuser/",
      method: "POST",
      headers: {
          "content-type": "application/xml",
      },
      body: xml
  }, (error, response, body) => {
    if(!error){
      callback(response.body);
    } else {
      console.log('error: '+ error);
    }
  });
}

module.exports = {callApi}
