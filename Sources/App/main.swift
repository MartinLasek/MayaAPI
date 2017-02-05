import Vapor
import VaporPostgreSQL
import Foundation
import HTTP

let drop = Droplet()
try drop.addProvider(VaporPostgreSQL.Provider.self)
drop.preparations.append(User.self)
drop.preparations.append(Image.self)

drop.post("receive-image") { req in
  
  let imageDispatcher = ImageDispatcher(drop: drop)

  if let contentType = req.headers["Content-Type"], contentType.contains("image/png"), let id = req.headers["id"], let bytes = req.body.bytes {
    
    // save sent image
    try imageDispatcher.saveImage(userUUID: id, bytes: bytes)
    
    // get image to return
    let file = try imageDispatcher.getImage()
    return Response(headers: ["Content-Type": "image/png; charset=utf-8"], body: Body(file))
  }
  
  return "could not save image"
}

drop.run()
