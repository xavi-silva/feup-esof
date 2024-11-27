Feature: Notifications

    Background: 
        Given a user has his notifications turned on

    Scenario: An event has its details changed
    Given the user has applied for an event
    When its start time is changed
    Then he should receive a notification informing him that the starting time has changed

    Scenario: An event will happen in a few days
    Given the user has applied for an event
    When there are only 24 hours left to its starting time
    Then he should receive a notification reminding him of his cleanup

    Scenario: Someone applies for an event
    Given that the event's capacity isn't full
    When someone registers on the event
    Then the organizer should get a notification saying a new user applied for his event

    Scenario: Getting updates on past events
    Given the user went to an event
    When the organizer posts an update
    Then the user should get a notification saying a recent clean-up had updates

