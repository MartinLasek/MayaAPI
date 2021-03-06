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
drop.preparations.append(WishEntity.self)
drop.preparations.append(VoteEntity.self)

let imageDispatcher = ImageDispatcher(drop: drop)
let userDispatcher = UserDispatcher(drop: drop)
let wishDispatcher = WishDispatcher(drop: drop)

// saves new image to database
drop.post("image/new") { req in
  
  if let isImage = req.headers["Content-Type"]?.contains("image/png"), let id = req.headers["phoneUUID"], let bytes = req.body.bytes {
    let user = try userDispatcher.saveUser(phoneUUID: id)
    let image = try imageDispatcher.saveImage(user: user, bytes: bytes)
    
    try imageDispatcher.saveUserSentImage(user: user, image: image)
  }
  
  return "EROR\n- user phone uuid is missing\nOR\n- content-type doesn't contain `image/png`\nOR\n- body bytes are missing"
}

// returns random image
drop.get("image/random") { req in
  
  if let phoneUUID = req.headers["phoneUUID"] {
    let user = try userDispatcher.getUserBy(phoneUUID: phoneUUID)
    let randomImage = try imageDispatcher.getRandomImage()
    
    try imageDispatcher.saveUserReceivedImage(user: user, image: randomImage)
    
    return try JSON(node: [
      "image": randomImage.name
    ])
  }
  
  return "user phone uuid is missing"
}

// returns sent images by given user
drop.get("image/list/sent") { req in
  
  if let id = req.headers["phoneUUID"] {
    let user = try userDispatcher.getUserBy(phoneUUID: id)
    let images = try imageDispatcher.getSentImagesBy(user: user)
    
    return try JSON(node: images)
  }
  
  return "user phone uuid is missing"
}

// returns received images by given user
drop.get("image/list/received") { req in
  
  if let id = req.headers["phoneUUID"] {
    let user = try userDispatcher.getUserBy(phoneUUID: id)
    let images = try imageDispatcher.getReceivedImagesBy(user: user)
    
    return try JSON(node: images)
  }
  
  return "user phone uuid is missing"
}

// returns json listing wishes with description, userPhoneUUID, votes
drop.get("wish/list") { req in
  
  if let userPhoneUUID = req.headers["phoneUUID"] {
    
    let wishes = try wishDispatcher.getAllWishes()
    var node = [Node]()
    
    for wish in wishes {
      
      guard let wishId = wish.id?.int else {
        throw WishError.wishIdNotFound
      }
      
      node.append(Node([
        "id": Node(wishId),
        "votes": Node(try wishDispatcher.getVotesFor(wish: wish)),
        "description": Node(wish.description),
        "userPhoneUUID": Node(wish.userPhoneUUID),
        "isOwner": Node(wish.userPhoneUUID == userPhoneUUID)
      ]))
    }
    
    return try JSON(node: node)
  }
  
  return "user phone uuid is missing"
}

drop.post("wish/new") { req in
  
  guard let userPhoneUUID = req.headers["phoneUUID"], let wishDescription = req.headers["wish"] else {
    throw WishError.phoneUUIDOrWishNotGiven
  }
  
  try wishDispatcher.create(wish: wishDescription, userPhoneUUID: userPhoneUUID)
  
  return "successful add a new wish"
}

drop.post("wish/vote") { req in
  
  guard let userPhoneUUID = req.headers["phoneUUID"], let wishIdAsString = req.headers["wishId"] else {
    throw WishError.phoneUUIDOrWishIdNotGiven
  }
  
  guard let wishId = Int(wishIdAsString) else {
    throw WishError.couldNotConvertId
  }
  
  try wishDispatcher.vote(wishId: wishId, userPhoneUUID: userPhoneUUID)
  
  return "successful voted for a wish"
}

// API Endpoint to be implemented
// * username/save
// * wish/new
// * wish/update/{id}

drop.run()
