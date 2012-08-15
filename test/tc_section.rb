#!/usr/bin/env ruby

require 'test/unit'
require '../scripts/wml_modifier'

class TestSection < Test::Unit::TestCase

	def setup
					@text = <<END
[unit_type]
	attack=2 
	{SET_VARIABLES}
[/unit_type]
END
					@sect = Section.new(:name => "Global",
														:subs => [Section.new(:name => "unit_type",
																									:keys => {"attack" => 2},
																									:macros => ["{SET_VARIABLES}"])])
	end

	def test_simple
					assert_equal(@text,@sect.dumpSection)
	end

end
