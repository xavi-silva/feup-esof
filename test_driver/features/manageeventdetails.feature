Feature: Event details management

    Rule: User must be the event organizer
    Background: 
        Given the user is on the event page

    Scenario: User changes event's description
    Given the user is on the 'Manage Event' page
    When the user "validly changes" the "Description" field - ex: "This place is a mess! Let's change it!"
    And the user clicks on the "Save" button
    Then the event should be updated successfully

    Scenario: User changes event's photo
    Given the user is on the 'Manage Event' page
    When the user "validly changes" the "Photo" field
    And the user clicks on the "Save" button
    Then the event should be updated successfully

    Scenario: User changes event's date
    Given the user is on the 'Manage Event' page
    When the user "validly changes" the "Date" field - ex: "25/08/2024"
    And the user clicks on the "Save" button
    Then the event should be updated successfully

    Scenario: User changes event's starting time
    Given the user is on the 'Manage Event' page
    When the user "validly changes" the "Time" field - ex: "18:30"
    And the user clicks on the "Save" button
    Then the event should be updated successfully

    Scenario: User changes event's capacity
    Given the user is on the 'Manage Event' page
    When the user "validly changes" the "Capacity" field - ex: "25"
    And the user clicks on the "Save" button
    Then the event should be updated successfully

    Scenario: User attempts to change event's name
    Given the user is on the 'Manage Event' page
    When the user clicks on the "Name" field
    Then he can't neither write nor delete nothing

    Scenario: User attempts to change event's location
    Given the user is on the 'Manage Event' page
    When the user clicks on the "Location" field
    Then he can't neither write nor delete nothing

    Scenario: User deletes event
    Given the user is on the event page 
    When the user click on the bin on the bottom left of the page
    And confirm the deletion
    Then the event gets deleted from the database

    Scenario: User accidentally clicks on the bin
    Given the user on the event page 
    When the user clicks on the bin on the bottom left of the page
    And cancels the deletion
    Then the event remains active
