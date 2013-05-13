require "cucumber/rspec/doubles"
require "time"

Before do

	original_now = Time.method(:now)

	@time_override = nil

	Time.stub(:now) do
		if @time_override
			@time_override
		else
			original_now.call
		end
	end

end

Given /^the time is (.+)$/ do
	|time_str|

	case time_str

		when /^(\d{4}-\d{2}-\d{2}) (\d{2}:\d{2}:\d{2})$/

			@time_override =
				Time.parse "#{$1}T#{$2}Z"

		when /^(\d+)$/

			@time_override =
				Time.at time_str.to_i

		else

			raise "Invalid time"

	end

end
