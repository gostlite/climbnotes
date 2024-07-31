// login exception
class UserNotFoundException implements Exception {}

class WrongCredentialsException implements Exception {}

class WrongPasswordException implements Exception {}

//Register exceptions
class WeakPasswordException implements Exception {}

class EmailAlreadyInUseException implements Exception {}

class InvalidEmailException implements Exception {}

//generic exceptions

class GenericAuthException implements Exception {}

class UserNotLoggedInException implements Exception {}
