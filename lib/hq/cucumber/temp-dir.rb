require "fileutils"
require "tmpdir"

Before "@temp-dir" do

	@project_dir = Dir.pwd
	@temp_dir = Dir.mktmpdir

	Dir.chdir @temp_dir

	$placeholders = {}

end

After "@temp-dir" do

	Dir.chdir @project_dir

	if $temp_dir_use_sudo
		system "sudo rm -rf #{@temp_dir}"
	else
		FileUtils.remove_entry_secure @temp_dir
	end

	@temp_dir = nil

end

Given /^a file "(.+)":$/ do
	|file_name, file_contents|

	raise "Must use @temp-dir tag" unless @temp_dir

	dir_name = File.dirname file_name

	FileUtils.mkdir_p dir_name

	regex_str =
		$placeholders.keys.map {
			|key|
			Regexp.quote key
		}.join("|")

	regex =
		Regexp.new regex_str

	file_contents =
		file_contents.gsub(regex) {
			|key| $placeholders[key]
		}

	File.open file_name, "w" do
		|file_io|

		file_io.write file_contents

	end

end

Given /^a directory "(.+)"$/ do
	|dir_name|

	raise "Must use @temp-dir tag" unless @temp_dir

	Dir.mkdir dir_name

end

Then /^there should be a file "(.+)":$/ do
	|file_name, file_contents_expect|

	raise "Must use @temp-dir tag" unless @temp_dir

	file_contents_actual =
		File.read file_name

	file_contents_actual.strip.should ==
		file_contents_expect.strip

end
