class AppStrings {
  // Authentication UI Strings
  static const String login = "Log In";
  static const String register = "Register";
  static const String email = "Email";
  static const String password = "Password";
  static const String name = "Name";
  static const String confirmPassword = "Confirm Password";
  static const String dontHaveAnAccount = "Don't have an account?";
  static const String alreadyHaveAnAccount = "Already have an account?";

  static const String yourTodos = "Your To-Dos";
  static const String createTodo = "Create To-Do";
  static const String title = "Title";
  static const String description = "Description";
  static const String selectDueDate = "Select Due Date";
  static const String pickDate = "Pick a Date";
  static const String saveTodo = "Save To-Do";
  static const String updateTodo = "Update To-Do";
  static const String editTodo = "Edit To-Do";

  // Success Messages
  static const String loginSuccessful = "Login successful!";
  static const String registrationSuccessful = "Registration successful!";
  static const String todoAddedSuccessfully = "To-do added successfully.";

  // Validation and Error Messages
  static const String pleaseEnterAValidEmailAddress = "Please enter a valid email address.";
  static const String passwordMustBeAtLeastSixCharactersLong = "Password must be at least 6 characters long.";
  static const String passwordsDoNotMatch = "Passwords do not match.";
  static const String nameCannotBeEmpty = "Name cannot be empty.";
  static const String allFieldsAreRequired = "All fields are required.";
  static const String noTodosFound = "No to-dos found.";
  static const String userNotRegistered = "User not found. Please register.";
  static const String incorrectPassword = "Incorrect password.";
  static const String registrationFailed = "Registration failed. Please try again.";
  static const String userCreationFailed = "User creation failed.";
  static const String theEmailAddressIsAlreadyInUseByAnotherAccount = "This email is already in use.";
  static const String loginFailed = "Login failed. Please try again.";
  static const String somethingWentWrongPleaseTryAgain = "Something went wrong. Please try again.";

  // Firebase Error Codes (these should not be shown directly to the user)
  static const String userNotFound = "user-not-found";
  static const String wrongPassword = "wrong-password";
  static const String emailAlreadyInUse = "email-already-in-use";
}