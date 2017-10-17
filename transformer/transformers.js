const xslt = require('xslt4node');
const fs = require('fs')
const {callApi} = require('../http/httpPosts')

// var execute = (xml, id, callback) => {
//   transformXML(xml, `${id}RQ`, (result) => {
//     //console.log('request transformed, calling api...')
//     callApi(result, (response) => {
//       //callback(response)
//       //console.log('response collected, transforming response...')
//       transformXML(response, `${id}RS`, (output) => {
//         callback(output)
//       })
//     })
//   })
// }

var execute = (xml, id, callback) => {
  transformXML(xml, `${id}RQ`).then((result) => {
    callApi(result, (response) => {
      transformXML(response, `${id}RS`).then((output) => {
        callback(response + '\n\n\n' + output)
      })
    })
  })
}

//with promise
var transformXML = (xml, id) => {
  return new Promise((resolve, reject) => {
    var config = {
        xsltPath: `${__dirname}/xslt/${id}.xslt`,
        source: xml,
        result: `${__dirname}/output.xml`,
        params: {
            discount: '2014/08/01'
        },
        props: {
            indent: 'yes'
        }
    };
    xslt.transform(config, (err) => {
        if (err) {
          reject(err);
        }

        readAndWipe(__dirname + '/output.xml').then((data) => {
          resolve(data)
        })
    });
  })
}

// var readAndWipe = (filePath, callback) => {
//   var data;
//   fs.readFile(filePath, 'utf-8', (err, contents) => {
//     if (!err){
//       data = contents;
//       fs.writeFile(filePath, '', (err) => {
//         if(err){
//           console.log(err)
//         }
//       })
//       callback(data)
//     }
//   })
// }

var readAndWipe = (filePath) => {
  return new Promise((resolve, reject) => {
  var data;
  fs.readFile(filePath, 'utf-8', (err, contents) => {
    if (err) {
      reject(err)
    }
    data = contents;
    fs.writeFile(filePath, '', () => {})
    resolve(data)
    })
  })
}

module.exports = {execute}

////transform using xslt module
// var transformXML = (xml, id, callback) => {
//   var stylesheet;
//   fs.readFile(`${__dirname}/xslt/${id}.xslt`, 'utf-8', (err, data) => {
//     if(!err){
//       stylesheet = data;
//       callback(xsl.xslt(xml, stylesheet))
//     }
//   })
// }

//transform using node_xslt module
// var transformXML = (xml, id, callback) => {
//   var stylesheet = xslt.readXsltFile(`${__dirname}/xslt/${id}.xslt`)
//   var source = xslt.readXmlString(xml)
//   callback(xslt.transform(stylesheet, source))
// }
