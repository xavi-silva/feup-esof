Feature: Resetting password

    Background:
        Given the user already has an account

    Scenario: User forgot his password
    Given the user is on the login page
    When the user clicks on the 'Forget Password'
    And inputs the email 'up202207183@up.pt'
    Then he should receive an email to reset his password
    And be redirected to the login page

    Scenario: Resetting password
    Given the user is on his mailbox
    When the user clicks the link to reset his password
    And writes '123456' as the new password
    And presses the 'Save' button
    Then he should be able to login with his new password

    Scenario: User wants to change his password
    Given the user is on the edit profile page
    When he clicks on the option to reset his password
    Then he should be redirected to the "Reset your password" page