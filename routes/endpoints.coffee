exports.routes = -> [
  method: "GET"
  path: "/scripts/{path*}"
  handler: 
    directory: 
      path: "./resources/scripts/"
,
  method: "GET"
  path: "/styles/{path*}"
  handler: 
    directory: 
      path: "./resources/styles/"
,
  method: "GET"
  path: "/libs/{path*}"
  handler: 
    directory: 
      path: "./resources/libs/"
,
  method: "GET"
  path: "/images/{path*}"
  handler:
    directory:
      path: "./resources/images/"
,
  method: "GET"
  path: "/textures/{path*}"
  handler: 
    directory: 
      path: "./resources/assets/textures/"
,
  method: "GET"
  path: "/fonts/{path*}"
  handler: 
    directory: 
      path: "./resources/assets/fonts/"
]