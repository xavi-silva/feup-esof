Feature: Checking past events on main page

    Background:
        Given a user is on the main page

    Scenario: A user wants to check all past events
    Given the user is on the main page
    When the user clicks on "Past events" or slides to the left
    Then all past events should be displayed