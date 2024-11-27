Feature: Deleting my comments on events

    Background:
        Given a user is on an event page

    Scenario: A user wants to delete a comment
    Given the user has commented on the event
    When "long pressing" the comment
    And clicking on "Yes" on the pop-up
    Then his comment should be deleted

    Scenario: A user accidentally presses his comment
    Given the user has commented on the event
    When "long pressing" the comment
    And clicking on "No" on the pop-up
    Then nothing happens

