import Vapor

class UserImageDispatcher {
  
  let drop: Droplet
  
  init(drop: Droplet) {
    self.drop = drop
  }
  
  func saveRelation(user: User, image: Image, type: String) throws {
    
    if let userId = user.id?.int, let imageId = image.id?.int {
      
      var userImage = UserImage(userId: userId, imageId: imageId, type: type)
      
      try userImage.save()
    }
  }
}
