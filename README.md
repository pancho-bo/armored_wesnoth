# ARERA Era for Wesnoth

Scripts to build ARERA era for Wesnoth

## Requisites

1. `wml_action gem`
  * `wml_action` still can not process inline comments like `"blahblah # wmllint blah blah"`, so have to remove them from fetched units file manually after failing step 3.

## Order to invoke:

1. Modify `unit_list`. It should contain all names of original units you want to have in your era.
2. `make createempty` to create modifications list templates
3. `make fetch` to fetch units from the game
4. Modify units modificatons list under the "modify" directory
5. `make era` copies units to your era
6. `make install` copies your era to wesnoth data directory
