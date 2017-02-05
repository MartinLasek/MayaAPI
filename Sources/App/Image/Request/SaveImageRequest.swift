import Vapor
import Foundation

class SaveImageRequest {
  
  let imageData: Data
  
  init(bytes: Bytes) {
    self.imageData = Data(bytes: bytes)
  }
}
