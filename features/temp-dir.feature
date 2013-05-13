Feature: Temporary directory and files

  Scenario:

    Given a file "features/support/env.rb":
      """
      require "hq/cucumber/temp-dir"
      """
    Given a file "features/support/steps.rb":
      """
      Then /^the file is created correctly$/ do
        File.read("abc.def").should == "Hello world"
      end
      """
    And a file "features/test.feature":
      """
      Feature:
        Scenario:
          Given a file "abc.def":
            \"\"\"
            Hello world
            \"\"\"
          Then the file is created correctly
      """

    When I run "cucumber"

    Then the exit status should be 0
    And the output should contain:
      """
      1 scenario (1 passed)
      2 steps (2 passed)
      """
