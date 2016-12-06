const Async = require("async");
const Hapi = require("hapi");
const Inert = require("inert");
const Endpoints = require("./routes/endpoints");
const IpGrabber = require("./helpers/ip_grabber");
const Pages = require("./routes/pages");

let localIp = IpGrabber.local();
let port = 8000;

let server = new Hapi.Server({
  connections: {
    routes: {
      files: {
        relativeTo: __dirname
      }
    }
  }
});

server.connection({ port: process.env.PORT || port });

server.ext("onPreResponse", (req, rep) => {
  let res = req.response;

  console.log("Outcoming response:");
  console.log(`in: ${new Date}`);
  console.log(`to: ${req.info.remoteAddress}`);
  console.log(`method: ${req.method}`);
  console.log(`url: ${req.url.path}`);
  console.log(`status: ${res.statusCode || res.output.statusCode}`);
  console.log();

  rep.continue();
});

Async.series([
  next => server.register(Inert, next),
  next => server.register(Endpoints, next),
  next => server.register(Pages, next),
  next => server.start(next)
], (err) => {
  if (err) throw err;

  console.log();
  console.log("---------- -------- ------ ---- --");
  console.log("----- ---- --- -- -");
  console.log(`Server running at ${localIp}:${port}`);
  console.log("----- ---- --- -- -");
  console.log("---------- -------- ------ ---- --");
  console.log();
});