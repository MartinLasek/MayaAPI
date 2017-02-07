import Vapor

class UserDispatcher {
  
  let drop: Droplet
  
  init(drop: Droplet) {
    self.drop = drop
  }
  
  func saveUser(phoneUUID: String) throws -> User {
    
    var user = User(phoneId: phoneUUID)
    let result = try User.query().filter("phoneid", user.phoneId).all().array
    
    if (result.isEmpty) {
      try user.save()
      return user
    }
    
    return result.first!
  }
}
