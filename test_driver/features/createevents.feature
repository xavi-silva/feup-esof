Feature: Event Creation

  Rule: User should be able to create events

  Background:
    Given that the user is on the events display page

  Scenario: User creates an event with valid information
    Given that the user is on the 'Create Event' page
    When the user "validly fills" in the "Name" field - ex: "Praia de Melres"
    And the user "validly fills" in the "Date" field - ex: "25/04/2024"
    And the user "validly fills" in the "Time" field - ex: "17:00"
    And the user "validly fills" in the "Location" field - ex: "Melres, Gondomar"
    And the user "validly fills" in the "Capacity" field - ex: "25"
    And the user "validly uploads" in the "Photo" field
    And the user "validly fills" in the "Description" field - ex: "This place is a mess! Let's change it!"
    And the user clicks on the "Create" button
    Then the event should be created successfully

  Scenario: User attempts to create an event with missing name
    Given that the user is on the 'Create Event' page
    When the user "validly fills" in the "Date" field - ex: "25/04/2024"
    And the user "validly fills" in the "Time" field - ex: "17:00"
    And the user "validly fills" in the "Location" field - ex: "Melres, Gondomar"
    And the user "validly fills" in the "Capacity" field - ex: "25"
    And the user "validly uploads" in the "Photo" field
    And the user "validly fills" in the "Description" field - ex: "This place is a mess! Let's change it!"
    And the user clicks on the "Create" button
    Then a "Please provide inputs to all boxes" message is shown

  Scenario: User attempts to create an event with missing date
    Given that the user is on the 'Create Event' page
    When the user "validly fills" in the "Name" field - ex: "Praia de Melres"
    And the user "validly fills" in the "Time" field - ex: "17:00"
    And the user "validly fills" in the "Location" field - ex: "Melres, Gondomar"
    And the user "validly fills" in the "Capacity" field - ex: "25"
    And the user "validly uploads" in the "Photo" field
    And the user "validly fills" in the "Description" field - ex: "This place is a mess! Let's change it!"
    And the user clicks on the "Create" button
    Then a "Please provide inputs to all boxes" message is shown

  Scenario: User attempts to create an event with missing starting time
    Given that the user is on the 'Create Event' page
    When the user "validly fills" in the "Name" field - ex: "Praia de Melres"
    And the user "validly fills" in the "Date" field - ex: "25/04/2024"
    And the user "validly fills" in the "Location" field - ex: "Melres, Gondomar"
    And the user "validly fills" in the "Capacity" field - ex: "25"
    And the user "validly uploads" in the "Photo" field
    And the user "validly fills" in the "Description" field - ex: "This place is a mess! Let's change it!"
    And the user clicks on the "Create" button
    Then a "Please provide inputs to all boxes" message is shown

  Scenario: User attempts to create an event with missing location
    Given that the user is on the 'Create Event' page
    When the user "validly fills" in the "Name" field - ex: "Praia de Melres"
    And the user "validly fills" in the "Date" field - ex: "25/04/2024"
    And the user "validly fills" in the "Time" field - ex: "17:00"
    And the user "validly fills" in the "Capacity" field - ex: "25"
    And the user "validly uploads" in the "Photo" field
    And the user "validly fills" in the "Description" field - ex: "This place is a mess! Let's change it!"
    And the user clicks on the "Create" button
    Then a "Please provide inputs to all boxes" message is shown

  Scenario: User attempts to create an event with missing capacity
    Given that the user is on the 'Create Event' page
    When the user "validly fills" in the "Name" field - ex: "Praia de Melres"
    And the user "validly fills" in the "Date" field - ex: "25/04/2024"
    And the user "validly fills" in the "Time" field - ex: "17:00"
    And the user "validly fills" in the "Location" field - ex: "Melres, Gondomar"
    And the user "validly uploads" in the "Photo" field
    And the user "validly fills" in the "Description" field - ex: "This place is a mess! Let's change it!"
    And the user clicks on the "Create" button
    Then a "Please provide inputs to all boxes" message is shown

  Scenario: User attempts to create an event with missing description
    Given that the user is on the 'Create Event' page
    When the user "validly fills" in the "Name" field - ex: "Praia de Melres"
    And the user "validly fills" in the "Date" field - ex: "25/04/2024"
    And the user "validly fills" in the "Time" field - ex: "17:00"
    And the user "validly fills" in the "Location" field - ex: "Melres, Gondomar"
    And the user "validly fills" in the "Capacity" field - ex: "25"
    And the user "validly uploads" in the "Photo" field
    And the user clicks on the "Create" button
    Then a "Please provide inputs to all boxes" message is shown

  Scenario: User inputs the location of the event
    Given that the user is on the 'Create Event' page
    When the user writes a location - ex: Praia de Melres
    Then the corresponding location should be displayed on the map