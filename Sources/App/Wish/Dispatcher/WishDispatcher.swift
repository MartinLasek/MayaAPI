import Vapor

class WishDispatcher {
  
  let drop: Droplet
  
  init(drop: Droplet) {
    self.drop = drop
  }
  
  func getAllWishes() throws -> [WishEntity] {
    let wishes = try WishEntity.query().all()
    return wishes
  }
  
  func getVotesFor(wish: WishEntity) throws -> Int {
    
    guard let wishId = wish.id?.int else {
      throw WishError.wishIdNotFound
    }
    
    let votes = try VoteEntity.query().filter("wishid", wishId).all()
    
    return votes.count
  }
  
  func create(wish: String, userPhoneUUID: String) throws {
    
    let user = try userDispatcher.getUserBy(phoneUUID: userPhoneUUID)
    var wish = WishEntity(description: wish, userPhoneUUID: userPhoneUUID)
    try wish.save()
    
    guard let wishId = wish.id?.int, let userId = user.id?.int else {
      throw WishError.couldNotConvertId
    }
    
    var vote = VoteEntity(userId: userId, wishId: wishId)
    try vote.save()
  }
  
  func vote(wishId: Int, userPhoneUUID: String) throws {
    
    let wish = try wishDispatcher.getWishBy(wishId: wishId)
    
    if (wish.userPhoneUUID == userPhoneUUID) {
      return
    }
    
    let user = try userDispatcher.getUserBy(phoneUUID: userPhoneUUID)
    
    guard let userId = user.id?.int, let wishId = wish.id?.int else {
      throw WishError.couldNotConvertId
    }
    
    var vote = VoteEntity(userId: userId, wishId: wishId)
    try vote.save()
  }
  
  func getWishBy(wishId: Int) throws -> WishEntity {
    
    guard let wish = try WishEntity.query().filter("id", wishId).first() else {
      throw WishError.wishNotFound
    }
    
    return wish
  }
}
