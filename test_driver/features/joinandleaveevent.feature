Feature: Joining and leaving events

    Background:
        Given the user is on the event page

    Scenario: User is applying for an event
    Given the event's capacity is not full
    When the user clicks on the "Join" button on the bottom right
    Then a pop-up should tell him he has successfully applied for the event
    And return to the events display page

    Scenario: Trying to apply for a full event
    Given the event's capacity is full
    When the user tries to apply for the event
    Then the join button should not appear

    Scenario: User is leaving an event
    Given the user has already applied for the event
    When the user clicks on the "Leave" button on the bottom right
    Then a pop-up should tell him he has successfully withdrawn from the event
    And return to the events display page





