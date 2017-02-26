import Vapor

class UserDispatcher {
  
  let drop: Droplet
  
  init(drop: Droplet) {
    self.drop = drop
  }
  
  func saveUser(phoneUUID: String) throws -> User {
    
    if let usr = try User.query().filter("phoneid", phoneUUID).first() {
      return usr
    }
    
    var user = User(phoneId: phoneUUID)
    try user.save()
    
    return user
  }
  
  func getUserBy(phoneUUID: String) throws -> User {
    
    guard let usr = try User.query().filter("phoneid", phoneUUID).first() else {
      throw UserError.userByPhoneUUIDNotFound
    }
    
    return usr
  }
}
