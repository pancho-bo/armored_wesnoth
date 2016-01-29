# Armored Era for Battle for Wesnoth

Scripts to build Armored Era for Wesnoth

## Requisites

1. Wesnoth installation
2. `ruby`, `rake`, `bundler`

## Order to invoke:

1. `bundle install`
2. Modify `Makefile` variables to match your paths.
3. Modify `unit_list`. It should contain all names of original units you want to have in your era.
4. `make fetch` to fetch units from the game.
5. If needed `make createempty` to create modifications list templates.
6. Modify units modificatons lists under the `modify` directory. There is `GENERIC.cfg` special list which will be applied to all units.
7. `make era` to copy units to your era.
8. `make install` to install your era to wesnoth data directory.
