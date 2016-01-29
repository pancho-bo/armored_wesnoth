# ARERA Era for Battle for Wesnoth

Scripts to build ARERA era for Wesnoth

## Requisites

1. Wesnoth installation
2. `ruby`, `rake`, `bundler`

## Order to invoke:

1. `bundle install`
2. Modify `Makefile` variables to match your pathes.
3. Modify `unit_list`. It should contain all names of original units you want to have in your era.
4. `make createempty` to create modifications list templates.
5. `make fetch` to fetch units from the game.
6. Modify units modificatons list under the `modify` directory.
7. `make era` copies units to your era.
8. `make install` copies your era to wesnoth data directory.
