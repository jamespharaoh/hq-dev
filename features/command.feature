Feature: Command invocation

  Background:

    Given a file "features/support/env.rb":
      """
      require "hq/cucumber/command"
      require "hq/cucumber/temp-dir"
      class CommandScript
        attr_accessor :args, :status, :stdout, :stderr
        def main
          @args.should == [ "arg1", "arg2" ]
          @stdout.puts "standard output"
          @stderr.puts "standard error"
          @status = 123
        end
      end
      $commands["command"] = CommandScript
      """

  Scenario: Invoke a script and check the output

    Given a file "features/support/steps.rb":
      """
      Then /^the file is created correctly$/ do
        File.read("abc.def").should == "Hello world"
      end
      """

    And a file "features/test.feature":
      """
      Feature:
        Scenario: Invoke script
          Given a file "args":
            \"\"\"
            arg1
            arg2
            \"\"\"
          When I invoke command with "args"
          Then the command stdout should be:
            \"\"\"
            standard output
            \"\"\"
          And the command stderr should be:
            \"\"\"
            standard error
            \"\"\"
          And the command exit status should be 123
      """

    When I run "cucumber"

    Then the output should contain:
      """
      1 scenario (1 passed)
      5 steps (5 passed)
      """
    And the exit status should be 0
