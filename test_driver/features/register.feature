Feature: Sign up

    Background:
      Given the user is in the "Signin" menu

    Scenario: The user tries to sign up with an existing email
        Given the user "incorrectly types" in the "Email" field - ex: "up202207183@up.pt"
        And the user "validly fills" in the "Password" field - ex: "123456"
        When the user presses the "Sign up" button
        Then a "The email address is already in use by another account" message is shown

    Scenario: The user tries to sign up with a badly formatted email
        Given the user "invalidly types" in the "Email" field - ex: "up202207183"
        And the user "validly fills" in the "Password" field - ex: "123456"
        When the user presses the "Sign up" button
        Then a "Enter a valid email" message is shown

    Scenario: The user tries to sign up with an invalid password
        Given the user "validly types" in the "Email" field - ex: "up202207183@up.pt"
        And the user "invalidly types" in the "Password" field - ex: "1"
        When the user presses the "Sign up" button
        Then a "Enter min. 6 characters" message is shown

    Scenario: The user tries to sign up without providing an email
        Given the user "validly types" in the "Password" field - ex: "123456"
        When the user presses the "Sign up" button
        Then a "Email address is required" message is shown
