When /^I run "(.*?)"$/ do
	|command|

	@command_output = `#{command}`
	@command_exit_status = $?.exitstatus

end

Then /^the exit status should be (\d+)$/ do
	|exit_status_str|

	@command_exit_status.should == exit_status_str.to_i

end

Then /^the output should contain:$/ do
	|string|

	@command_output.should include string

end
