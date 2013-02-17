#
# Makefile for ARERA era
#

WESNOTH_VERSION=1.11
WESNOTH_DATA_DIR=/Applications/Wesnoth.app/Contents/Resources/data
WESNOTH_LIB_DATA_DIR=/Users/pancho/Library/Application\ Support/Wesnoth_${WESNOTH_VERSION}/data
ERA_UNITS_DIR=era/ARERA_MP_era/units
ERA_DIR=era/ARERA_MP_era
ERA_NAME=ARERA_MP_era
UNITS_DIR=units
MODIFY_DIR=modify
BUILD_DIR=build

.PHONY: clean fetch initunits era createempty modify unitsclean

era: clean modify

createempty:
	scripts/create_empty.sh unit_list ${MODIFY_DIR}
	scripts/init_units.sh ${MODIFY_DIR}

fetch: 
	scripts/fetch_units.sh ${WESNOTH_DATA_DIR} ${UNITS_DIR}
	scripts/init_units.sh ${UNITS_DIR}

initunits: 
	scripts/init_units.sh ${UNITS_DIR}

clean:
	-rm ${BUILD_DIR}/*

unitsclean:
	-rm ${UNITS_DIR}/*

modify:
	scripts/alter_units.sh scripts/wml_modifier.rb ${UNITS_DIR} ${MODIFY_DIR} ${BUILD_DIR}

install:
	scripts/install_units.sh ${BUILD_DIR} ${ERA_UNITS_DIR}
	rm -rf ${WESNOTH_LIB_DATA_DIR}/add-ons/${ERA_NAME}
	cp -R ${ERA_DIR} ${WESNOTH_LIB_DATA_DIR}/add-ons/
