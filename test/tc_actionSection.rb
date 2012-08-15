#!/usr/bin/env ruby

require 'test/unit'
require '../scripts/wml_modifier'

class TestActionSection < Test::Unit::TestCase

	def setup

					@text_archer = <<END
#This is my new unit
[unit_type]
	+ [powershot]
			strength=2
		[/powershot]
	[attack]
	/ type=melee
		damage=4
	[/attack]
	+ description=_ "Archer.
Longrange attack."
	hp=4
	+ {SET_VARIABLES}
[/unit_type]
END

#					@sect_archer = Section.new(:name => "Global",
#														:subs => [Section.new(:name => "unit_type",
#																									:keys => {"hp" => 2,
#																														"description" => "_ \"Archer.\nLongrange attack.\""},
#																									:macros => ["{SET_VARIABLES}"])],
#														:macros => "\#This is my new unit")
#
					@sect_from_file = ActionSection.new.fromFile(File.open("fixtures/as_from_file.cfg"))

	end

	def test_simple

					#assert_equal(@text_archer,@sect_archer.dumpSection)
					assert_equal([ "Global",
											 { :action => "=", :value => "\#Footman"},
												"unit_type",
												[ { :action => "+", :value => { "description" => " _ \"Strong.\n\nVery strong.\""}},
												{ :action => "=", :value => { "hp" => "100" } }],
												{ :action => "-", :value => "{SET_VARIABLES}"},
												"+",
				 								{ "type" => "melee" }],

												[ @sect_from_file.name,
													@sect_from_file.macros[0],
													@sect_from_file.subs[0][:value].name,
													@sect_from_file.subs[0][:value].keys,
													@sect_from_file.subs[0][:value].macros[0],
											 		@sect_from_file.subs[0][:value].subs[0][:action],
											 		@sect_from_file.subs[0][:value].subs[1][:value].filter])
	end

end
