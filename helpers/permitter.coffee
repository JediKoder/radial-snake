Hapi = require "hapi"
IpGrabber = require "./ip_grabber"

exports.file = (path, permissions, req, rep) ->
  permissions = permissions.concat [IpGrabber.local()]
  remoteAddress = req.info.remoteAddress

  if permissions.indexOf(remoteAddress) is -1
    error = Hapi.error.forbidden "Missing permissions"
    error.output.statusCode = 403
    error.reformat()
    rep error
  else
    rep.file path