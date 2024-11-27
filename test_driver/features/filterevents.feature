Feature: Event deletion 

    Rule: User must be an admin
    Background: 
        Given the user is on the events display page

    Scenario: Admin deletes event
    Given the admin is on the event page 
    When the admin click on the bin on the bottom left of the page
    And confirm the deletion
    Then the event gets deleted from the database

    Scenario: Admin accidentally clicks on the bin
    Given the admin on the event page 
    When the admin clicks on the bin on the bottom left of the page
    And cancels the deletion
    Then the event remains active
    


