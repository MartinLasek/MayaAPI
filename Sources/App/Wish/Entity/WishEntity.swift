//
//  WishlistEntity.swift
//  MayaAPI
//
//  Created by Martin Lasek on 16.03.17.
//
//

import Vapor

final class WishEntity: Model {
  
  static var entity = "wishes"
  var exists: Bool = false
  var id: Node?
  var userPhoneUUID: String
  var description: String
  
  init(description: String, userPhoneUUID: String) {
    self.description = description
    self.userPhoneUUID = userPhoneUUID
  }
  
  init(node: Node, in context: Context) throws {
    description = try node.extract("description")
    userPhoneUUID = try node.extract("userphoneuuid")
  }
  
  func makeNode(context: Context) throws -> Node {
    return try Node(node: [
      "description": description,
      "userphoneuuid": userPhoneUUID
    ])
  }
  
  static func prepare(_ database: Database) throws {
    
    try database.create(entity) { wish in
      wish.id()
      wish.string("description")
      wish.string("userphoneuuid")
    }
  }
  
  static func revert(_ database: Database) throws {
    try database.delete(entity)
  }
}
