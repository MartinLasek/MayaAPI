import Vapor

final class UserImage: Model {
  
  static let sent = "sent"
  static let received = "received"
  
  var id: Node?
  var exists: Bool = false
  var userId: Int
  var imageId: Int
  var type: String
  
  init(userId: Int, imageId: Int, type: String) {
    self.userId = userId
    self.imageId = imageId
    self.type = type
  }
  
  init(node: Node, in context: Context) throws {
    userId = try node.extract("userid")
    imageId = try node.extract("imageid")
    type = try node.extract("type")
  }
  
  func makeNode(context: Context) throws -> Node {
    return try Node(node: [
        "userid": userId,
        "imageid": imageId,
        "type": type
    ])
  }
  
  static func prepare(_ database: Database) throws {
    try database.create("userimages", closure: { userimage in
      userimage.id()
      userimage.string("userid")
      userimage.string("imageid")
      userimage.string("type")
    })
  }
  
  static func revert(_ database: Database) throws {
    try database.delete("userimages")
  }
}
