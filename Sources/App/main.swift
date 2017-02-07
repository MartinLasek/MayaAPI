import Vapor
import VaporPostgreSQL
import Foundation
import HTTP

let drop = Droplet()
try drop.addProvider(VaporPostgreSQL.Provider.self)
drop.preparations.append(User.self)
drop.preparations.append(Image.self)
drop.preparations.append(UserImage.self)

drop.post("receive-image") { req in
  
  let imageDispatcher = ImageDispatcher(drop: drop)
  let userDispatcher = UserDispatcher(drop: drop)
  let userImageDispatcher = UserImageDispatcher(drop: drop)

  if let contentType = req.headers["Content-Type"], contentType.contains("image/png"), let id = req.headers["id"], let bytes = req.body.bytes {
    
    // save user
    let user = try userDispatcher.saveUser(phoneUUID: id)
    
    // save image
    let image = try imageDispatcher.saveImage(user: user, bytes: bytes)
    
    // save user image relation
    try userImageDispatcher.saveRelation(user: user, image: image, type: UserImage.sent)
    
    // get image to return
    let file = try imageDispatcher.getImage()
    return Response(headers: ["Content-Type": "image/png; charset=utf-8"], body: Body(file))
  }
  
  return "could not save image"
}

drop.run()
