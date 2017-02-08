import Vapor

final class Image: Model {
  
  static let imageDirectory = "Public/images"
  
  var id: Node?
  var exists: Bool = false
  var userId: Int
  let name: String
  let path: String
  
  init(userId: Int, name: String, path: String) {
    self.userId = userId
    self.name = name
    self.path = path
  }
  
  init(node: Node, in context: Context) throws {
    userId = try node.extract("userid")
    name = try node.extract("name")
    path = try node.extract("path")
  }
  
  func makeNode(context: Context) throws -> Node {
    return try Node(node: [
      "id": id,
      "userid": userId,
      "name": name,
      "path": path
    ])
  }
  
  static func prepare(_ database: Database) throws {
    try database.create("images") { user in
      user.id()
      user.int("userid")
      user.string("name")
      user.string("path")
    }
  }
  
  static func revert(_ database: Database) throws {
    try database.delete("images")
  }
}
