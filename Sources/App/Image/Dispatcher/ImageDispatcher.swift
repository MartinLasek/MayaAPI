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
    
    let path = drop.workDir + Image.imageDirectory
    let name = user.phoneId + "-" + UUID().uuidString + ".jpg"
    
    let imageNode = try Node(node: [
      "name": name,
      "path": path
    ])
    
    var image = try Image(node: imageNode)
    
    let saveURL = URL(fileURLWithPath: image.path).appendingPathComponent(image.name, isDirectory: false)
    
    // save image to disk
    let data = Data(bytes: bytes)
    try data.write(to: saveURL)
    
    // save image to database
    try image.save()
    
    let result = try Image.query().filter("name", image.name).all().array
    
    /*
    if (result.isEmpty) {
        throw "couldn't find image with \(image.name)"
    }
    */
    
    return result.first!
  }
  
  /*
  ** Gets a random image from DB
  */
  func getImage() throws -> Data {
    
    let images = try Image.query().all()
    let randomIndex = arc4random_uniform(UInt32(images.count))
    let image = images[Int(randomIndex)]
    let getURL = URL(fileURLWithPath: image.path).appendingPathComponent(image.name, isDirectory: false)
    
    return try Data(contentsOf: getURL)
  }
}
