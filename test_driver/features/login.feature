Feature: Log in

    Rule: User needs to have an account
    Background:
      Given the user is in the "Login" menu

    Scenario: The user logs in with correct credentials
      Given the user "incorrectly types" in the "Email" field - ex: "up202207183@up.pt"
      And the user "correctly types" in the "Password" field - ex: "123456"
      When the user presses the "Sign in" button
      Then the user is in the "Main" menu

    Scenario: The user tries to log in with wrong email
      Given the user "incorrectly types" in the "Email" field - ex: "up202200000@up.pt"
      And the user "correctly types" in the "Password" field - ex: "123456"
      When the user presses the "Sign in" button
      Then the user is in the "Login" menu

    Scenario: The user tries to log in with wrong password
      Given the user "correctly types" in the "Email" field - ex: "up202207183@up.pt"
      And the user "incorrectly types" in the "Password" field - ex: "987654"
      When the user presses the "Sign in" button
      Then the user is in the "Login" menu

    Scenario: The user tries to log in with a badly formatted email
      Given the user "invalidly types" in the "Email" field - ex: "up202207183"
      And the user "correctly types" in the "Password" field - ex: "123456"
      When the user presses the "Sign in" button
      Then a "Enter a valid email" message is shown

    Scenario: The user tries to log in with an invalid password
      Given the user "correctly types" in the "Email" field - ex: "up202207183@up.pt"
      And the user "invalidly types" in the "Password" field - ex: "1"
      When the user presses the "Sign in" button
      Then a "Enter min. 6 characters" message is shown

    Scenario: The user tries to log in without an email
      Given the user "correctly types" in the "Password" field - ex: "123456"
      When the user presses the "Sign in" button
      Then a "Email address is required" message is shown
