Feature: Temporary directory and files

  Background:

    Given a file "features/support/env.rb":
      """
      require "hq/cucumber/temp-dir"
      """

  Scenario: Create a file

    Given a file "features/support/steps.rb":
      """
      Before do
        $placeholders["${name}"] = "world"
      end
      """

    And a file "features/test.feature":
      """
      Feature:
        Scenario: Simple file
          Given a file "abc.def":
            \"\"\"
            Hello world
            \"\"\"
          Then there should be a file "abc.def":
            \"\"\"
            Hello world
            \"\"\"
        Scenario: Placeholders
          Given a file "abc.def":
            \"\"\"
            Hello ${name}
            \"\"\"
          Then there should be a file "abc.def":
            \"\"\"
            Hello world
            \"\"\"
      """

    When I run "cucumber"

    Then the exit status should be 0
    And the output should contain:
      """
      2 scenarios (2 passed)
      4 steps (4 passed)
      """

  Scenario: Create a directory

    Given a file "features/support/steps.rb":
      """
      Then /^the directory exists$/ do
        Dir.exist?("some-dir").should be_true
      end
      Then /^the directory does not exist$/ do
        Dir.exist?("some-dir").should be_false
      end
      """

    And a file "features/test.feature":
      """
      Feature:
        Scenario: Create dir
          Given a directory "some-dir"
          Then the directory exists
        Scenario: Remove between runs
          Then the directory does not exist
      """

    When I run "cucumber"

    Then the exit status should be 0
    And the output should contain:
      """
      2 scenarios (2 passed)
      3 steps (3 passed)
      """
