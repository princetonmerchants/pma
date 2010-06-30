Feature: Managing users
  In order to allow others to edit content and design assets
  As an administrator I want to manage the set of users
  
  Background:
    Given I am logged in as "admin"
    And I go to the "users" admin page
  Scenario: Listing users
    Then I should see "Admin"
    And I should see "Designer"
    And I should see "Existing"
    # And a host of others
    
  Scenario: View a user
    When I view a user
    Then I should see "Edit User"
  
  Scenario: Create new user
    When I follow "New User"
    And I fill in "Name" with "New Guy"
    And I fill in "E-mail" with "newguy@example.com"
    And I fill in "Username" with "new_guy"
    And I fill in "New Password" with "password"
    And I fill in "Confirm New Password" with "password"
    And I press "Create User"
    Then I should be on the users list
    And I should see "New Guy"
  
  Scenario: Display form errors on submit
    When I follow "New User"
    And I fill in "Name" with "New Guy"
    And I fill in "E-mail" with "newguy@example.com"
    And I press "Create User"
    Then I should see an error message
    And I should see the form
    
  Scenario: Edit existing user
    When I follow "Designer"
    Then I should see the form
    When I fill in "Name" with "Old Guy"
    And I fill in "Username" with "oldguy"
    And I uncheck "Designer"
    And I press "Save Changes"
    Then I should see "Old Guy"
    But I should not see "Designer"

  Scenario: Cannot remove self
    When I attempt to remove my own account
    Then I should see an error message
    And I should see "You cannot delete yourself"

  Scenario: Cannot forcefully delete self
    When I attempt to delete my own account
    Then I should see an error message
    And I should see "You cannot delete yourself"
  
  Scenario: Delete other users
    When I follow "Remove"
    Then I should see "permanently remove"
    And I should see "Another"
    When I press "Delete User"
    And I should not see "Another"