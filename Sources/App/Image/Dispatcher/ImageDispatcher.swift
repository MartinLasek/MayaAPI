import Vapor
import Foundation

class ImageDispatcher {
  
  let drop: Droplet
  
  init(drop: Droplet) {
    self.drop = drop
  }
  
  /*
  ** Saves given image to DB and to Disk
  */
  func saveImage(user: User, bytes: Bytes) throws -> Image {
    
    guard let userId = user.id?.int else {
      throw UserError.userIdNotAvailble
    }
    
    let path = drop.workDir + Image.imageDirectory
    let name = user.phoneId + "-" + UUID().uuidString + ".jpg"
    
    var image = Image(userId: userId, name: name, path: path)
    let saveURL = URL(fileURLWithPath: image.path).appendingPathComponent(image.name, isDirectory: false)
    
    // save image to disk
    let data = Data(bytes: bytes)
    try data.write(to: saveURL)
    
    // save image to database
    try image.save()
    
    return image
  }
  
  // gets a random image from DB
  func getRandomImage() throws -> Image {
    
    let images = try Image.query().all()
    let randomIndex = arc4random_uniform(UInt32(images.count))
    
    return images[Int(randomIndex)]
  }
  
  // saves image and user sent image relation
  func saveUserSentImage(user: User, image: Image) throws {
    
    guard let userId = user.id?.int, let imageId = image.id?.int else {
      throw ImageError.userIdOrImageIdIsMissing
    }
    
    var sentImage = SentImage(userId: userId, imageId: imageId)
    try sentImage.save()
  }
  
  // saves user received image relation
  func saveUserReceivedImage(user: User, image: Image) throws {
    
    guard let userId = user.id?.int, let imageId = image.id?.int else {
      throw ImageError.userIdOrImageIdIsMissing
    }
    
    var receivedImage = ReceivedImage(userId: userId, imageId: imageId)
    try receivedImage.save()
  }
}
