require "tmpdir"

Before do

	@old_dir = Dir.pwd
	@temp_dir = Dir.mktmpdir

	Dir.chdir @temp_dir

end

After do

	FileUtils.remove_entry_secure @temp_dir

	Dir.chdir @old_dir

end

Given /^a file "(.*?)":$/ do
	|file_name, file_contents|

	File.open file_name, "w" do
		|file_io|

		file_io.write file_contents

	end

end
