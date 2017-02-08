import Vapor
import VaporPostgreSQL
import Foundation
import HTTP

let drop = Droplet()
try drop.addProvider(VaporPostgreSQL.Provider.self)
drop.preparations.append(User.self)
drop.preparations.append(Image.self)
drop.preparations.append(SentImage.self)
drop.preparations.append(ReceivedImage.self)

drop.post("sent-image") { req in
  
  let imageDispatcher = ImageDispatcher(drop: drop)
  let userDispatcher = UserDispatcher(drop: drop)

  if let contentType = req.headers["Content-Type"], contentType.contains("image/png"), let id = req.headers["id"], let bytes = req.body.bytes {
    
    // save user
    let user = try userDispatcher.saveUser(phoneUUID: id)
    
    let image = try imageDispatcher.saveImage(user: user, bytes: bytes)
    let randomImage = try imageDispatcher.getRandomImage()
    
    try imageDispatcher.saveUserSentImage(user: user, image: image)
    try imageDispatcher.saveUserReceivedImage(user: user, image: randomImage)
    
    let getURL = URL(fileURLWithPath: randomImage.path).appendingPathComponent(randomImage.name, isDirectory: false)
    let file = try Data(contentsOf: getURL)
    
    return Response(headers: ["Content-Type": "image/png; charset=utf-8"], body: Body(file))
  }
  
  return "could not save image"
}

drop.run()
