@run
Feature: Authentication

    Scenario: I want to know when I can sign in
        Given I am not logged in
        When I enter a valid username
            And I enter a valid password
        Then I can sign in

    Scenario: I want to know if I can't sign in
        Given I am not logged in
        When I have not entered a valid username
            Or I have not entered a valid password
        Then I can't sign in

    Scenario: I want to see my password
        Given I am not logged in
        When I enter a valid password
            And I want to see what I typed
        Then My password is not obscured

    Scenario: I log in successfully
        Given I am not logged in
        When I enter valid credentials
            And I sign in
        Then I see the next screen

    Scenario: I enter the wrong credentials
        Given I am not logged in
        When I enter a valid username
        But I enter an invalid password
        Then I am not logged in
