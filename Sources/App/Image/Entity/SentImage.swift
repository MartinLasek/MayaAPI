import Vapor

final class SentImage: Model {
  
  var id: Node?
  var exists: Bool = false
  var userId: Int
  var imageId: Int
  
  init(userId: Int, imageId: Int) {
    self.userId = userId
    self.imageId = imageId
  }
  
  init(node: Node, in context: Context) throws {
    userId = try node.extract("userid")
    imageId = try node.extract("imageid")
  }
  
  func makeNode(context: Context) throws -> Node {
    return try Node(node: [
        "userid": userId,
        "imageid": imageId
    ])
  }
  
  static func prepare(_ database: Database) throws {
    try database.create("sentimages", closure: { userimage in
      userimage.id()
      userimage.string("userid")
      userimage.string("imageid")
    })
  }
  
  static func revert(_ database: Database) throws {
    try database.delete("sentimages")
  }
}
