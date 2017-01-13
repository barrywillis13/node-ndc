const request = require('request')
const fs = require('fs')
var xml = fs.readFileSync(__dirname + '/AirAvailRQ.xml').toString();
var doPost = () => {
  request({
      url: "https://sws.qa.sita.aero/hal_superuser/",
      method: "POST",
      headers: {
          "content-type": "application/xml",
      },
      body: xml
  }, (error, response, body) => {
    if(!error){
      console.log(response.body);
    } else {
      console.log('Error Occured!')
    }
  })
}

doPost();
