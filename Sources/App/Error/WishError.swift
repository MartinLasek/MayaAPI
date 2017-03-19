enum WishError: Error {
  
  case wishIdNotFound
  case phoneUUIDOrWishNotGiven
  case couldNotConvertId
  case phoneUUIDOrWishIdNotGiven
  case wishNotFound
  case cannotVoteForOwnWish
}
