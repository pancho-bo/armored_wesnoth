#!/usr/bin/env ruby

# This script reads actions from wml-modify file and applies that actions to a wml file

require 'rubygems'
require 'ftools'
#require 'profile'


class Section
		attr_accessor :name,:subs,:keys,:macros

		@@tab_counter=-1

		def initialize(values={})
				@name=values[:name]||""
				@subs=values[:subs]||Array.new
				@keys=values[:keys]||Hash.new
				@macros=values[:macros]||Array.new
		end

		def fromFile(file,section_name="Global")

				#debug
				#puts "Setting section name to: #{section_name}"

				@name=section_name

				while not file.eof? do
					line=file.readline
					#debug
					#puts "Readed #{line}"

					case line
						when /^\s*$/; next
						when /\s*\[\/(\w+)\]/;
								#debug
								#puts "Found exit from: #{$1}"
								if @name != $1 then
									puts "Found exit from #{$1}, expected #{@name}"
									exit
								end
								break
						when /\s*\[(\w+)\]/;  
								#debug
								#puts "Found new section: #{$1}" 
								@subs.push(Section.new.fromFile(file,$1))
								next
						when /\s*(\w+)=(.*)/;
								#debug
								#puts "Found new key,value pair: #{$1} => #{$2}" 
								key=$1
								value=$2
								#multiline keys are evil
								if line=~/\"/ and not line=~/.*\".*\".*/ then
									value+="\n"
									begin
											line=file.readline
											value+=line
									end until line=~/\"/
									value.chomp!
									#debug
									#puts "Found multiline key:" 
									#print value
								end
								@keys.store(key,value)
								next
						when /\s*(\{.*\})/;
								#debug
								#puts "Found new macro: #{$1}" 
								@macros.push($1)
								next
						when /\s*(\#.*)/;
								#debug
								#puts "Found new misc: #{$1}" 
								@macros.push($1)
								next
						else
								print "Can't understand \"#{line}\""
								exit
					end
				end

				return self
		end

		def dumpSection
				text=String.new
				text+="\t"*@@tab_counter if @@tab_counter >= 0
				text+="[#{@name}]\n" if @name != "Global"
				@keys.each_pair do |key,value|
						text+="\t"*(@@tab_counter+1) if @@tab_counter >= 0
						text+="#{key}=#{value}\n"
				end
				@macros.each do |macro|
						text+="\t"*(@@tab_counter+1) if @@tab_counter >= 0
						text+="#{macro}\n"
				end
				@subs.each do |sub|
						@@tab_counter+=1
						text+=sub.dumpSection
				end
				text+="\t"*@@tab_counter if @@tab_counter >= 0
				text+="[/#{@name}]\n" if @name != "Global"
				@@tab_counter-=1
				return text
		end

		def fromActionSection(act_sect)
				@name=act_sect.name
				#debug
				#puts "Section name: [#{[@name]}]"
				act_sect.subs.each do |sub|
						#debug
						#puts "Section sub: #{sub[:value].name}"
						@subs.push(sub[:value])
				end
				act_sect.keys.each do |key|
						#debug
						#puts "Section key: #{key[:value].to_a.join("=")}"
						@keys.update(key[:value])
				end
				act_sect.macros.each do |macro|
						#debug
						#puts "Section macro: #{macro[:value]}"
						@macros.push(macro[:value])
				end

				return self
		end
end

class ActionSection

		attr_accessor :name,:subs,:keys,:macros,:filter

		@@tab_counter=-1

		def initialize(values={})
				@name=values[:name]||""
				@subs=values[:subs]||Array.new
				@keys=values[:keys]||Array.new
				@macros=values[:macros]||Array.new
				@filter=values[:filter]||Hash.new
		end

		def fromFile(file,section_name="Global")

				#debug
				#puts "Setting section name to: #{section_name}"

				@name=section_name

				while not file.eof? do
					line=file.readline
					#debug
					#puts "Readed #{line}"

					case line
						when /^\s*$/; next
						when /\s*\[\/(\w+)\]/;
								#debug
								#puts "Found exit from: #{$1}"
								if @name != $1 then
									puts "Found exit from #{$1}, expected #{@name}"
									exit
								end
								break
						when /\s*\/\s*(\w+)=(.*)/;
								#debug
								#puts "Found new filter: #{$1} => #{$2}" 
								@filter.store($1,$2)
								next
						when /\s*([\=\-\+]?)\s*\[(\w+)\]/;
								#debug
								#puts "Found new section: #{$2} with action: #{$1}" 
								action=$1
								action = "=" if action == ""
								@subs.push({:action => action, :value => ActionSection.new.fromFile(file,$2)})
								next
						when /\s*([\=\-\+]?)\s*(\w+)=(.*)/;
								#debug
								#puts "Found new key,value pair: #{$2} => #{$3} , with action: #{$1}" 
								action=$1
								action = "=" if action == ""
								key=$2
								value=$3
								if line=~/\"/ and not line=~/.*\".*\".*/ then
									value+="\n"
									begin
											line=file.readline
											value+=line
									end until line=~/\"/
									value.chomp!
									#debug
									#puts "Found multiline key:" 
									#print value
								end
								@keys.push( {:action => action, :value => {key => value} })
								next
						when /\s*([\=\-\+]?)\s*(\{.*\})/;
								#debug
								#puts "Found new macro: #{$2} , with action: #{$1}" 
								action=$1
								action = "=" if action == ""
								@macros.push( {:action => action, :value => $2 } )
								next
						when /\s*([\=\-\+]?)\s*(\#.*)/;
								#debug
								#puts "Found new misc: #{$2} , with action: #{$1}" 
								action=$1
								action = "=" if action == ""
								@macros.push( {:action => action, :value => $2 } )
								next
						else
								print "Can't understand \"#{line}\""
								exit
					end
				end

				return self
		end

		def dumpSection
				text=String.new
				text+="\t"*@@tab_counter if @@tab_counter >= 0
				text+="[#{@name}]\n" if @name != "Global"
				@filter.each do |filter|
						text+="\t"*(@@tab_counter+1) if @@tab_counter >= 0
						text+="/ " + filter.to_a.join("=") + "\n"
				end
				@keys.each do |key|
						text+="\t"*(@@tab_counter+1) if @@tab_counter >= 0
						text+=key[:action] + " #{key[:value].to_a.join("=")}\n"
				end
				@macros.each do |macro|
						text+="\t"*(@@tab_counter+1) if @@tab_counter >= 0
						text+=macro[:action] + " #{macro[:value]}\n"
				end
				@subs.each do |sub|
						text+=sub[:action] + " "
						@@tab_counter+=1
						text+=sub[:value].dumpSection
				end
				text+="\t"*@@tab_counter if @@tab_counter >= 0
				text+=("[/#{@name}]\n") if @name != "Global"
				@@tab_counter-=1
				return text
		end

		def applyActionSection(section)
				return if @name != section.name
				if @filter then
						@filter.each_key do |key|
								return if not section.keys.has_key?(key)
								return if section.keys[key] != @filter[key]
						end
				end
				#debug
				#puts "Applying [#{@name}] action section to [#{section.name}] with filter: #{@filter}" 
				@keys.each do |key|
						#debug
						#puts "Processing key: #{key[:value].to_a.join("=")}"
						section.keys.update(key[:value]) if key[:action] =~ /\+|\=/
								#TODO: if action == "-"
				end
				@macros.each do |macro|
						#debug
						#puts "Adding macro: #{macro[:value]}"
						section.macros.push(macro[:value]) if macro[:action] =~ /\+|\=/
						section.macros.delete(macro[:value]) if macro[:action] =~ /\-/
				end
				@subs.each do |act_sub|
						section.subs.each do |sub|
							act_sub[:value].removeActionSection(section,sub,act_sub[:value].filter) if act_sub[:action] =~ /\-/ and sub.name==act_sub[:value].name
							act_sub[:value].applyActionSection(sub) if act_sub[:action] =~ /\=/
						end
				end
				@subs.each do |act_sub|
							act_sub[:value].addActionSection(section) if act_sub[:action] =~ /\+/
				end
		end

		def addActionSection(section)
				#debug
				#puts "Adding [#{@name}] action section to [#{section.name}]"
				section.subs.push(Section.new.fromActionSection(self))
		end

		def removeActionSection(section,sub,filter=nil)
				#debug
				#puts "Removing [#{sub.name}] section from [#{section.name}] with filter #{filter.to_a.join('=')}"
				if filter then
						filter.each_key do |key|
						   	return if not sub.keys.has_key?(key)
							return if sub.keys[key] != @filter[key]
						end
				end
				section.subs.delete(sub)
		end

end

if __FILE__ == $0 then
		if ARGV.count == 2 then
				target_name=ARGV[0]
				modlist_name=ARGV[1]

				if not File.exist?(target_name) then
						puts "Invalid target file: #{target_name}"
						exit
				end
				if not File.exist?(modlist_name) then
						puts "Invalid modlist file: #{modlist_name}"
						exit
				end

				target=File.open(target_name)
				modlist=File.open(modlist_name)
				target_root=Section.new.fromFile(target)
				#print target_root.dumpSection
				
				modlist_root=ActionSection.new.fromFile(modlist)
				#modlist_root.dumpSection
				
				modlist_root.applyActionSection(target_root)
				print target_root.dumpSection
				
				target.close
				modlist.close
		else
				puts "Usage: wml_modifier {target_file} {modlist_file}"
		end
end

