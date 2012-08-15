#!/usr/bin/env ruby

require 'test/unit'
require '../scripts/wml_modifier'

class TestSection < Test::Unit::TestCase

	def setup

					@text_archer = <<END
#This is my new unit
[unit_type]
	description=_ "Archer.
Longrange attack."
	hp=2
	{SET_VARIABLES}
[/unit_type]
END

					@sect_archer = Section.new(:name => "Global",
														:subs => [Section.new(:name => "unit_type",
																									:keys => {"hp" => 2,
																														"description" => "_ \"Archer.\nLongrange attack.\""},
																									:macros => ["{SET_VARIABLES}"])],
														:macros => "\#This is my new unit")
					@sect_footman = Section.new.fromFile("Global",File.open("fixtures/footman.wml"))

	end

	def test_simple
					assert_equal(@text_archer,@sect_archer.dumpSection)
					assert_equal([ "Global",
											 "\#Footman",
												"unit_type",
												{ "description" => " _ \"Strong.\n\nVery strong.\"",
													"hp" => "100" },
												"{SET_VARIABLES}" ],
												[ @sect_footman.name,
													@sect_footman.macros[0],
													@sect_footman.subs[0].name,
													@sect_footman.subs[0].keys,
													@sect_footman.subs[0].macros[0] ])
	end

end
