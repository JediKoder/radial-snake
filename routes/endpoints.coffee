module.exports = [
  method: "GET"
  path: "/scripts/{path*}"
  handler: 
    directory: 
      path: "./app/scripts/"
,
  method: "GET"
  path: "/styles/{path*}"
  handler: 
    directory: 
      path: "./app/styles/"
,
  method: "GET"
  path: "/libs/{path*}"
  handler: 
    directory: 
      path: "./app/libs/"
,
  method: "GET"
  path: "/images/{path*}"
  handler:
    directory:
      path: "./app/images/"
,
  method: "GET"
  path: "/textures/{path*}"
  handler: 
    directory: 
      path: "./app/assets/textures/"
,
  method: "GET"
  path: "/fonts/{path*}"
  handler: 
    directory: 
      path: "./app/assets/fonts/"
]