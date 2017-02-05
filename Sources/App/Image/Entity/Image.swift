import Vapor

final class Image: Model {
  
  static let imageDirectory = "Public/images"
  
  var id: Node?
  var exists: Bool = false
  let name: String
  let path: String
  
  init(node: Node, in context: Context) throws {
    name = try node.extract("name")
    path = try node.extract("path")
  }
  
  func makeNode(context: Context) throws -> Node {
    return try Node(node: ["id": id, "name": name, "path": path])
  }
  
  static func prepare(_ database: Database) throws {
    try database.create("images") { user in
      user.id()
      user.string("name")
      user.string("path")
    }
  }
  
  static func revert(_ database: Database) throws {
    try database.delete("images")
  }
}
