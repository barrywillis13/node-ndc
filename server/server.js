const express = require('express');
const fs = require('fs');
const bodyParser = require('body-parser')

const {execute} = require('../transformer/transformers')
const {identify} = require('../middleware/identify')
const {logger} = require('../middleware/logger')

const port = process.env.PORT || 3000;
var app = express();
var options = {
  inflate: true,
  limit: '100kb',
  type: 'text/xml'
};

app.use(bodyParser.raw(options));
app.use(identify)
app.use(logger)
////////////////////////////////////////////////////////////////////////////////

app.post('/', (req, res) => {
  execute(req.body.toString(), req.id.toString(), (result) => {
    res.send(result)
  })
});

////////////////////////////////////////////////////////////////////////////////

app.listen(port, () => {
  console.log(`Server is up on port ${port}`);
})
