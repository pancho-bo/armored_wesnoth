#
# Makefile for ARERA era
#

WESNOTH_VERSION=1.12
WESNOTH_APP=Wesnoth.app
WESNOTH_BIN=~/Applications/${WESNOTH_APP}/Contents/MacOS/Wesnoth
WESNOTH_DATA_DIR=~/Applications/${WESNOTH_APP}/Contents/Resources/data
WESNOTH_LIB_DATA_DIR=/Users/pancho/Library/Application\ Support/Wesnoth_${WESNOTH_VERSION}/data

ERA_UNITS_DIR=era/Armored_Era/units
ERA_DIR=era/Armored_Era
ERA_NAME=Armored_Era
ERA_PREFIX=ARERA
UNITS_DIR=units
MODIFY_DIR=modify
BUILD_DIR=build

.PHONY: clean fetch era createempty modify unitsclean test test-orcs

era: clean modify

createempty:
	scripts/create_empty.sh ${UNITS_DIR} ${MODIFY_DIR}

fetch: 
	scripts/fetch_units.sh ${WESNOTH_DATA_DIR} ${UNITS_DIR}
	scripts/remove_inline_comments.sh ${UNITS_DIR}
	ruby scripts/init_units.rb ${UNITS_DIR} ${ERA_PREFIX}


clean:
	-rm ${BUILD_DIR}/*
	-rm ${ERA_UNITS_DIR}/*

unitsclean:
	-rm ${UNITS_DIR}/*

modify:
	scripts/alter_units.sh ${UNITS_DIR} ${MODIFY_DIR} ${BUILD_DIR}

install:
	scripts/install_units.sh ${BUILD_DIR} ${ERA_UNITS_DIR}
	rm -rf ${WESNOTH_LIB_DATA_DIR}/add-ons/${ERA_NAME}
	cp -R ${ERA_DIR} ${WESNOTH_LIB_DATA_DIR}/add-ons/

test:
	${WESNOTH_BIN} -m --era ARERA --parm 1:gold:60 --parm 2:gold:60 --controller 2:ai
	
test-orcs:
	${WESNOTH_BIN} -m --era ARERA --parm 1:gold:60 --parm 2:gold:60 --controller 2:ai --side 1:ARERA_Northerners


