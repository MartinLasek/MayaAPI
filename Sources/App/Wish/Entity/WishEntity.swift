//
//  WishlistEntity.swift
//  MayaAPI
//
//  Created by Martin Lasek on 16.03.17.
//
//

import Vapor

final class WishEntity: Model {
  
  var exists: Bool = false
  var id: Node?
  var userId: Int
  var description: String
  static var entity = "wishes"
  
  init(description: String, userId: Int) {
    self.description = description
    self.userId = userId
  }
  
  init(node: Node, in context: Context) throws {
    description = try node.extract("description")
    userId = try node.extract("userid")
  }
  
  func makeNode(context: Context) throws -> Node {
    return try Node(node: [
      "description": description,
      "userid": userId
    ])
  }
  
  static func prepare(_ database: Database) throws {
    
    try database.create(entity) { wish in
      wish.id()
      wish.string("description")
      wish.string("userid")
    }
  }
  
  static func revert(_ database: Database) throws {
    try database.delete(entity)
  }
}
