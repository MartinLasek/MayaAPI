import Vapor
import Foundation

class ImageDispatcher {
  
  let drop: Droplet
  
  init(drop: Droplet) {
    self.drop = drop
  }
  
  /// Saves given image to Database and to Disk
  func saveImage(user: User, bytes: Bytes) throws -> Image {
    
    guard let userId = user.id?.int else {
      throw UserError.userPhoneUUIDNotFound
    }
    
    let path = drop.workDir + Image.imageDirectory
    let name = user.phoneId + "-" + UUID().uuidString + ".jpg"
    var image = Image(userId: userId, name: name, path: path)
    let saveURL = URL(fileURLWithPath: image.path).appendingPathComponent(image.name, isDirectory: false)
    let data = Data(bytes: bytes)
    
    try data.write(to: saveURL)
    try image.save()
    
    return image
  }
  
  /// Gets a random image from Database.
  func getRandomImage() throws -> Image {
    let images = try Image.query().all()
    
    guard !images.isEmpty else {
      throw ImageError.noImagesFoundInDatabase
    }
    
    let randomIndex = arc4random_uniform(UInt32(images.count))
    return images[Int(randomIndex)]
  }
  
  /// Saves relation of sent image with user to database.
  func saveUserSentImage(user: User, image: Image) throws {
    
    guard let userId = user.id?.int, let imageId = image.id?.int else {
      throw ImageError.userIdOrImageIdIsMissing
    }
    
    var sentImage = SentImage(userId: userId, imageId: imageId)
    try sentImage.save()
  }
  
  /// Saves relation of image received with user to database.
  func saveUserReceivedImage(user: User, image: Image) throws {
    
    guard let userId = user.id?.int, let imageId = image.id?.int else {
      throw ImageError.userIdOrImageIdIsMissing
    }
    
    var receivedImage = ReceivedImage(userId: userId, imageId: imageId)
    try receivedImage.save()
  }
  
  /// Returns array of names of images sent by given user
  func getAllImagesBy(user: User) throws -> [String] {
    
    guard let userId = user.id?.int else {
      throw UserError.userPhoneUUIDNotFound
    }
    
    let images = try Image.query().filter("userid", userId).all().map {$0.name}
    return images
  }
}
