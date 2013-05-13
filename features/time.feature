Feature: Time manipulation

  Background:

    Given a file "features/support/env.rb":
      """
      require "hq/cucumber/time"
      """

    And a file "features/support/steps.rb":
      """
      Then /^the time should be correct$/ do
        Time.now.to_i.should >= 1368458271
      end
      Then /^the time should be (\d+)$/ do
        |time_str|
        Time.now.to_i.should == time_str.to_i
      end
      """

  Scenario: Normal behaviour

    Given a file "features/test.feature":
      """
      Feature:
        Scenario:
          Then the time should be correct
      """

    When I run "cucumber"

    Then the exit status should be 0
    And the output should contain:
      """
      1 scenario (1 passed)
      1 step (1 passed)
      """

  Scenario: Override with integer

    Given a file "features/test.feature":
      """
      Feature:
        Scenario:
          Given the time is 123456
          Then the time should be 123456
      """

    When I run "cucumber"

    Then the exit status should be 0
    And the output should contain:
      """
      1 scenario (1 passed)
      2 steps (2 passed)
      """
