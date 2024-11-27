Feature: Edit profile

    Background:
        Given the user is on the edit profile page

    Scenario: User changes "First Name" successfully 
    Given the user clicks on the "First Name" field 
    When the user writes a name - ex: "Pedro"
    And clicks on the "Save" button on the bottom right
    Then a pop-up should tell him his name was changed
    And return to the profile page

    Scenario: User tries to delete his "First Name"
    Given the user clicks on the "First Name" field 
    When the user deletes the field
    Then a warning should tell him that field must not be empty 

    Scenario: User changes "Last Name" successfully 
    Given the user clicks on the "Last Name" field 
    When the user writes a name - ex: "Mendes"
    And clicks on the "Save" button on the bottom right
    Then a pop-up should tell him his name was changed
    And return to the profile page

    Scenario: User tries to delete his "Last Name"
    Given the user clicks on the "Last Name" field 
    When the user deletes the field
    Then a warning should tell him that field must not be empty 

    Scenario: User changes his "Username" successfully
    Given the user clicks on the "Username" field
    When the user writes a username - ex: "pedromendes2301"
    And the username is not on the database yet
    And clicks on the "Save" button on the bottom right
    Then a pop-up should tell him his name was changed
    And return to the profile page

    Scenario: User tries to delete his "Username"
    Given the user clicks on the "Username" field
    When the user writes a username - ex: "pedromendes2301"
    And clicks on the "Save" button on the bottom right
    Then a pop-up should tell him his name was changed
    And return to the profile page

    Scenario: User tries to change his "Username" to a used one
    Given the user clicks on the "Username" field
    When the user writes a username - ex: "pedromendes2301"
    And the username is already on the database yet
    Then a warning should tell him that username is already in use

    Scenario: User changes his "Photo" successfully
    Given the user clicks on the "Photo" field
    When the user chooses or takes a photo
    And clicks on the "Save" button on the bottom right
    Then a pop-up should tell him his photo was changed
    And return to the profile page

    



    











