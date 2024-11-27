Feature: Find upcoming events

    Background: 
        Given the user is logged in

    Scenario: User searching for an event
    Given the user is on his profile page
    When the user clicks on the "Home" icon on the bottom of the page
    Then he is redirected to the "Events Display" page and can now scroll through the events