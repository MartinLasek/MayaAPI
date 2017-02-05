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
  func saveImage(userUUID: String, bytes: Bytes) throws {
    
    let path = drop.workDir + Image.imageDirectory
    let name = userUUID + "-" + UUID().uuidString + ".jpg"
    
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
  }
  
  /*
  ** Gets an image from DB
  */
  func getImage() throws -> Data {
    
    let randomImage = try Image.query().first()
    let getURL = URL(fileURLWithPath: (randomImage?.path)!).appendingPathComponent((randomImage?.name)!, isDirectory: false)
    
    return try Data(contentsOf: getURL)
  }
}
