const {transformXML} = require('../transformer/transformers')
const {callApi} = require('../http/httpPosts')
const fs = require('fs')


fs.readFile(__dirname + '/AirShoppingRQ.xml', (err, data) => {
  if(!err){
    var rawRequest = data.toString();
    var id = 'shop';

    transformXML(rawRequest, `${id}RQ`, (result) => {
      console.log(result)
  //     callApi(result, (response) => {
  //
  //       transformXML(response, `${id}RS`, (output) => {
  //         console.log(output)
  //   })
  // })
    })
  } else {
  console.log('File Read Error: '+ err)
}
})

//console.log(getResult(xml, 'shop'))
