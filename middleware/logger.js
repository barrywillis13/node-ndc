var logger = (req, res, next) => {
  var date = new Date().toISOString()
  console.log(`${req.id} request received: ${date} `)
  next()
}

module.exports = {logger}
