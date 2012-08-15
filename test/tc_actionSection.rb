#!/usr/bin/env ruby

require 'test/unit'
require '../scripts/wml_modifier'

class TestActionSection < Test::Unit::TestCase

	def setup
					sect=ActionSection.new( :name => "ASName", :subs => [], :keys => {}, :macros => [] )
	end

	def test_simple
					
	end

end
