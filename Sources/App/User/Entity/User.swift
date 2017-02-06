import Vapor

final class User: Model {
  var id: Node?
  var exists: Bool = false
  var phoneId: String
  var username: String?
  
  init(phoneId: String) {
    self.phoneId = phoneId
  }
  
  init(node: Node, in context: Context) throws {
    username = try? node.extract("username")
    phoneId = try node.extract("phoneid")
  }
  
  func makeNode(context: Context) throws -> Node {
    return try Node(node: [
      "id": id,
      "phoneid": phoneId,
      "username": username
    ])
  }
  
  static func prepare(_ database: Database) throws {
    try database.create("users") { user in
      user.id()
      user.string("phoneid")
      user.string("username", optional: true)
    }
  }
  
  static func revert(_ database: Database) throws {
    try database.delete("users")
  }
}
