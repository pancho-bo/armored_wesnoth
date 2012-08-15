#!/usr/bin/env ruby

require 'test/unit'
require '../scripts/wml_modifier'

class TestSection < Test::Unit::TestCase

	def setup

					@text_dump = <<END
#This is my new unit
[unit_type]
	description=_ "Archer.
Longrange attack."
	hp=2
	{SET_VARIABLES}
[/unit_type]
END

					@sect_dump = Section.new(:name => "Global",
														:subs => [Section.new(:name => "unit_type",
																									:keys => {"hp" => 2,
																														"description" => "_ \"Archer.\nLongrange attack.\""},
																									:macros => ["{SET_VARIABLES}"])],
														:macros => "\#This is my new unit")

					@sect_from_file = Section.new.fromFile(File.open("fixtures/s_from_file.cfg"))

	end

	def test_simple

					assert_equal(@text_dump,@sect_dump.dumpSection)
					assert_equal([ "Global",
											 "\#Footman",
												"unit_type",
												{ "description" => " _ \"Strong.\n\nVery strong.\"",
													"hp" => "100" },
												"{SET_VARIABLES}" ],
												[ @sect_from_file.name,
													@sect_from_file.macros[0],
													@sect_from_file.subs[0].name,
													@sect_from_file.subs[0].keys,
													@sect_from_file.subs[0].macros[0] ])
	end

end
