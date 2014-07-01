#!/usr/bin/env ruby

require 'wml_action'

unless ARGV.size == 2
  puts 'Usage: init_units.rb DIR'
  exit
end

dir = ARGV[0]
prefix = ARGV[1]

unless Dir.exists? dir
  puts "init_units: Directory #{dir} does not exists"
  exit
end

Dir.chdir dir
units = Dir.entries '.'
units.delete_if {|f| File.directory? f } 
units.delete_if {|f| f.match /^#{prefix}/ }

units.each do |f|
  unit=WMLAction::Document.from_file(f).root
  unit.attrs['id'] = prefix + '_' + unit.attrs['id'].strip unless unit.attrs['id'].match /^#{prefix}/
  advances = unit.attrs['advances_to']
  unless advances.nil? || advances.empty?
    advances = advances.split(',').
      map!(&:strip).
      map! do |u|
        case u
        when /^#{prefix}/ then u
        when 'null' then u
        else prefix + '_' + u
        end
      end
    unit.attrs['advances_to'] = advances.join(',')
  end
  File.open("#{prefix}_#{f}",'w') { |f| f.write unit.to_s }
  File.delete(f)
end
