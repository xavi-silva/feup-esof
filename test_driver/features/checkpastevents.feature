Feature: Tracking of a user's participation in past events

    Background:
        Given a user has already attended an event

    Scenario: A user wants to check his past events
    Given the user is logged in
    When the user clicks on the right icon of the bottom appbar
    Then he should get redirected to his profile and past events should appear on the bottom of the page

