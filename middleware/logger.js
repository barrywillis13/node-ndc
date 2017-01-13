var logger = (req, res, next) => {
  var date = new Date().toISOString()
  console.log(`${req.id} request recieved: ${date} `)
  next()
}

module.exports = {logger}
