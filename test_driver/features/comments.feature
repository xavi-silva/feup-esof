Feature: Comments

    Background: 
        Given the user is on the event page

    Scenario: An user wants to give feedback about an event
    Given the event has already happened
    When the user scrolls until the comments section
    And clicks on the comment field
    And types a message - ex:"Awful event. Terrible experience."
    Then it should be displayed under the event's post

    Scenario: An organizer wants to check feedback on his event
    Given the event has already happened
    When the organizer scrolls until the comments section
    Then he should see the comments of his event

    Scenario: An organizer wants to give updates after the event
    Given the event has already happened
    When the organizer scrolls until the comments section
    And clicks on the comment field
    And types a message - ex: "Good job everyone. Marcelo Rebelo de Sousa himself has congratulated your efforts!"
    Then it should be displayed under the event's post
 

    