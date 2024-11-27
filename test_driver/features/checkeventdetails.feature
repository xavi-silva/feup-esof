Feature: View all the information regarding an event

    Background:
        Given the user is logged in

    Scenario: User checking an event's details
    Given the user is on the events display page
    When the user clicks on an event - ex: "Praia de Melres"
    Then he is redirected to the "Event" page where the details are displayed

    Scenario: User checking past event details
    Given the user is on his profile page
    And has attended an event - ex: "Praia de Melres"
    When he clicks on the event - ex: "Praia de Melres"
    Then he is redirected to the "Event" page where the details are displayed
