import Vapor
import Foundation

class ImageDispatcher {
  
  let drop: Droplet
  
  init(drop: Droplet) {
    self.drop = drop
  }
  
  func saveImage(userUUID: String, bytes: Bytes) throws {
    
    let path = drop.workDir + Image.imageDirectory
    let name = userUUID + "-" + UUID().uuidString + ".jpg"
    
    let imageNode = try Node(node: [
      "name": name,
      "path": path
    ])
    
    let saveURL = URL(fileURLWithPath: path).appendingPathComponent(name, isDirectory: false)
    
    // save image to path
    let data = Data(bytes: bytes)
    try data.write(to: saveURL)
    
    // save image to database
    var image = try Image(node: imageNode)
    try image.save()
  }
  
  func getImage() throws -> Data {
    
    let randomImage = try Image.query().first()
    let getURL = URL(fileURLWithPath: (randomImage?.path)!).appendingPathComponent((randomImage?.name)!, isDirectory: false)
    
    return try Data(contentsOf: getURL)
  }
}
