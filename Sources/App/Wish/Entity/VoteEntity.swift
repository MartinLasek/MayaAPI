//
//  UserWishlistEntity.swift
//  MayaAPI
//
//  Created by Martin Lasek on 16.03.17.
//
//

import Vapor

final class VoteEntity: Model {
  
  var exists: Bool = false
  var id: Node?
  var userId: Int
  var wishId: Int
  static var entity = "vote"
  
  init(userId: Int, wishId: Int) {
    self.userId = userId
    self.wishId = wishId
  }
  
  init(node: Node, in context: Context) throws {
    userId = try node.extract("userid")
    wishId = try node.extract("wishid")
  }
  
  func makeNode(context: Context) throws -> Node {
    return try Node(node: [
      "userid": userId,
      "wishid": wishId
    ])
  }
  
  static func prepare(_ database: Database) throws {
    try database.create(entity) { userwish in
      userwish.id()
      userwish.int("userid")
      userwish.int("wishid")
    }
  }
  
  static func revert(_ database: Database) throws {
    try database.delete(entity)
  }
}
