#!/usr/bin/env ruby

# Test for wml_modifier that ActionSection beign applied correctly

require "../wml_modifier"
require "test/unit"

class TestWMLModifier < Test::Unit::TestCase

				def setup
								original=File.open("extents/archer.cfg")
								modlist=File.open("extents/archer_modify.cfg")

								@section=Section.new.fromFile(original)
								@actionSection=ActionSection.new.fromFile(modlist)

				end

				def test_applying_actionsection
								@actionSection.applyActionSection(@section)

								unit_type_section=@section.subs[0]

								##keys tests
								#assignment
								assert_equal("elf",unit_type_section.keys["race"])
								#insert
								assert_not_nil(unit_type_section.keys["level"])
								assert_equal("1",unit_type_section.keys["level"])
								#TODO: delete key
								

								##macros tests
								#insert
								assert(unit_type_section.macros.include?("{MAKE_BETTER_MACROS}"))
								#delete
								assert_equal(false,unit_type_section.macros.include?("{MAKE_GOOD_MACROS}"))
								#delete section
								#assert_equal(0,unit_type_section.subs.select{|s| s.name=="mov_anim"}.length)
								
								
								##subsections tests
								#insert 
								attack_anim_sections=unit_type_section.subs.select{|s| s.name=="attack_anim"}
								assert_equal(false,attack_anim_sections.empty?)
								assert(1,attack_anim_sections.length)
								#assignment
								attack_sections=unit_type_section.subs.select{|s| s.name="attack"}
								assert_equal(2,attack_sections.select{|s| s.macros.include?("{PIERCE_MACROS}")}.length)
								

								#filtered assignment
								attack_sections=unit_type_section.subs.select{|s| s.name=="attack"}
								assert_equal("12", attack_sections[attack_sections.index{|s| s.keys["range"]=="ranged"}].keys["damage"])
								assert_equal("2", attack_sections[attack_sections.index{|s| s.keys["range"]=="melee"}].keys["damage"])

								#TODO: filtered delete
								resists_sections=unit_type_section.subs.select{|s| s.name=="resists"}
								assert_equal(1,resists_sections.length)
								assert_equal("10",resists_sections[0].keys["blunt"])
								
				end

end	
