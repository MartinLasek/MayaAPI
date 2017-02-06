import Vapor

class UserDispatcher {
  
  let drop: Droplet
  
  init(drop: Droplet) {
    self.drop = drop
  }
  
  func saveUser(userPhoneUUID: String) throws {
    
    var user = User(phoneId: userPhoneUUID)
    let result = try User.query().filter("phoneid", userPhoneUUID).all().array
    
    if (result.isEmpty) {
      try user.save()
    }
  }
}
