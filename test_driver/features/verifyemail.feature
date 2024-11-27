Feature: Email verification

    Background:
        Given the user has submitted his email and password

    Scenario: Confirming the registration email
    Given that the user received the confirmation email after registering for an account
    When the user clicks the link inside the email
    Then he should be able to fill the remaining details of his account