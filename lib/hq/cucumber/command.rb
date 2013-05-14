require "shellwords"

$commands = {}

When /^I invoke (\S+) with "([^"]+)"$/ do
	|command_name, args_name|

	command_class = $commands[command_name]

	script = command_class.new

	script.args = Shellwords.split File.read(args_name)

	script.stdout = StringIO.new
	script.stderr = StringIO.new

	script.main

	@command_exit_status = script.status
	@command_stdout = script.stdout.string
	@command_stderr = script.stderr.string

end

Then /^the command stdout should be:$/ do
	|stdout_expect|

	@command_stdout.strip.should == stdout_expect.strip

end

Then /^the command stderr should be:$/ do
	|stderr_expect|

	@command_stderr.strip.should == stderr_expect.strip

end

Then /^the command exit status should be (\d+)$/ do
	|exit_status_expect_str|

	exit_status_expect = exit_status_expect_str.to_i

	@command_exit_status.should == exit_status_expect

end

