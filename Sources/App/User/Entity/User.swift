import Vapor

final class User: Model {
  var id: Node?
  var exists: Bool = false
  let username: String?
  let phoneId: String
  
  init(node: Node, in context: Context) throws {
    username = try node.extract("username")
    phoneId = try node.extract("phoneId")
  }
  
  func makeNode(context: Context) throws -> Node {
    return try Node(node: ["id": id, "username": username, "phoneId": phoneId])
  }
  
  static func prepare(_ database: Database) throws {
    try database.create("users") { user in
      user.id()
      user.string("username")
      user.string("phoneId")
    }
  }
  
  static func revert(_ database: Database) throws {
    try database.delete("users")
  }
}
