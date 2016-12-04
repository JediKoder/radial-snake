const Boom = require("boom");
const Hapi = require("hapi");
const IpGrabber = require("./ip_grabber");

const sourcePermissions = [IpGrabber.local(), "127.0.0.1", "localhost"];

function file(path, permissions, req, rep) {
  permissions = permissions.concat(sourcePermissions);
  let remoteAddress = req.info.remoteAddress;

  if (permissions.indexOf(remoteAddress) == -1) {
    let err = new Boom.forbidden("Missing permissions");
    return rep(err);
  }

  rep.file(path);
}

module.exports = {
  file
};