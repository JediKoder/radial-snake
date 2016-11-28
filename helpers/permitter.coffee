Boom = require "boom"
Hapi = require "hapi"
IpGrabber = require "./ip_grabber"

sourcePermissions = [
  IpGrabber.local()
  "127.0.0.1"
  "localhost"
]

exports.file = (path, permissions, req, rep) ->
  permissions = permissions.concat sourcePermissions
  remoteAddress = req.info.remoteAddress

  if permissions.indexOf(remoteAddress) is -1
    error = new Boom.forbidden "Missing permissions"
    rep error
  else
    rep.file path