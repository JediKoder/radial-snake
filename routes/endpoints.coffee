exports.route = (route) ->
  route
    method: "GET"
    path: "/scripts/{path*}"
    handler: 
      directory: 
        path: "./resources/scripts/"

  route
    method: "GET"
    path: "/styles/{path*}"
    handler: 
      directory: 
        path: "./resources/styles/"
        
  route  
    method: "GET"
    path: "/libs/{path*}"
    handler: 
      directory: 
        path: "./resources/libs/"
        
  route
    method: "GET"
    path: "/images/{path*}"
    handler:
      directory:
        path: "./resources/images/"
        
  route
    method: "GET"
    path: "/textures/{path*}"
    handler: 
      directory: 
        path: "./resources/assets/textures/"
        
  route
    method: "GET"
    path: "/fonts/{path*}"
    handler: 
      directory: 
        path: "./resources/assets/fonts/"