Hapi = require "hapi"
IpGrabber = require "./ip_grabber"

exports.page = (file, permissions, req, rep) ->
  permissions = permissions.concat [IpGrabber.local()]
  name = file.match(/\/[^\/]*\.html$/)[0]
  name = name.substr(1, name.length - 6).replace /_/g, " "
  remoteAddress = req.info.remoteAddress

  console.log new Date
  console.log "#{remoteAddress} is trying to get #{name} page"

  if permissions.indexOf(remoteAddress) is -1
    console.log "permission denied"
    error = Hapi.error.forbidden "Missing permissions"
    error.output.statusCode = 403
    error.reformat()
    rep error
  else
    console.log "permission granted"
    rep.file file

  console.log()