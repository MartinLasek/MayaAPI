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
}
