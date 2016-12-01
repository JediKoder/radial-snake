import Hapi from "hapi";
import Pack from "../package.json";
import Permitter from "../helpers/permitter";

register.attributes = {
  name: "pages",
  version: Pack.version
};

export function register(server, options, next) {
  server.route({ method: "GET", path: "/", handler: getGame });
  server.route({ method: "GET", path: "/test", handler: getSpecRunner });

  next();
}

function getGame(req, rep) {
  let path = "./views/game.html";
  let permissions = [];

  Permitter.file(path, permissions, req, rep);
}

function getSpecRunner(req, rep) {
  let path = "./views/spec_runner.html";
  let permissions = [];

  Permitter.file(path, permissions, req, rep);
}