const Pack = require("../package.json");

register.attributes = {
  name: "endpoints",
  version: Pack.version
};

function register(server, options, next) {
  server.route({
    method: "GET",
    path: "/scripts/{path*}",
    handler: {
      directory: {
        path: "./resources/scripts/"
      }
    }
  });

  server.route({
    method: "GET",
    path: "/styles/{path*}",
    handler: {
      directory: {
        path: "./resources/styles/"
      }
    }
  });

  server.route({
    method: "GET",
    path: "/libs/{path*}",
    handler: {
      directory: {
        path: "./resources/libs/"
      }
    }
  });

  server.route({
    method: "GET",
    path: "/images/{path*}",
    handler: {
      directory: {
        path: "./resources/images/"
      }
    }
  });

  server.route({
    method: "GET",
    path: "/textures/{path*}",
    handler: {
      directory: {
        path: "./resources/assets/textures/"
      }
    }
  });

  server.route({
    method: "GET",
    path: "/fonts/{path*}",
    handler: {
      directory: {
        path: "./resources/assets/fonts/"
      }
    }
  });

  next();
}

module.exports = {
  register
};