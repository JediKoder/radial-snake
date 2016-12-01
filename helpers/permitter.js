import Boom from "boom";
import Hapi from "hapi";
import IpGrabber from "./ip_grabber";

const sourcePermissions = [IpGrabber.local(), "127.0.0.1", "localhost"];

export function file(path, permissions, req, rep) {
  permissions = permissions.concat(sourcePermissions);
  let remoteAddress = req.info.remoteAddress;

  if (permissions.indexOf(remoteAddress) == -1) {
    let err = new Boom.forbidden("Missing permissions");
    return rep(err);
  }

  rep.file(path);
}