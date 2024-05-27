# Production Management System

This Prolog-based Production Management System provides a user interface for managing resources, inventory, and production schedules. The system allows users to display current resources and inventory, add resources, produce products, schedule production on specific machines, and add new products.

## Features

1. **Display Inventory**: View the current inventory of products.
2. **Display Resources**: View the available resources and their quantities.
3. **Add Resource**: Add a new resource or increase the quantity of an existing resource.
4. **Produce Product**: Produce a specified quantity of a product, consuming the necessary resources.
5. **Schedule Production**: Schedule the production of a product on a specified machine.
6. **Add Product**: Add new products to the system with specified resource requirements and production time.

## File Structure

- **main.pl**: The main Prolog file containing the logic for the production management system.
- **README.md**: This documentation file.

## How to Run

1. Ensure you have SWI-Prolog installed on your machine.
2. Open SWI-Prolog and consult the `main.pl` file using the following command:
   ```prolog
   ?- [main].
3. Start the user interface by executing the start_interface/0 predicate:
?- start_interface.
4. A dialog window will appear, providing buttons for various operations.
## Code Explanation
# Dynamic Predicates
- resource/2: Stores the available resources and their quantities.
- inventory/2: Stores the current inventory of products and their quantities.
- machine_schedule/2: Stores the production schedule for each machine.
- new_product/3: Stores the definition of new products, their resource requirements, and production time.
- machine/2: Stores the machines and the products they can produce.
# Predicates
- available_resource/2: Checks if a specified quantity of a resource is available.
- product/3: Retrieves the definition of a product.
- can_produce/2: Checks if a specified quantity of a product can be produced based on available resources.
- consume_resources/2: Consumes the required resources to produce a specified quantity of a product.
- update_inventory/2: Updates the inventory after production.
- produce/2: Produces a specified quantity of a product if possible.
- add_resource/2: Adds a specified quantity of a resource.
- display_inventory/0: Displays the current inventory.
- display_resources/0: Displays the available resources.
- schedule_production/3: Schedules production of a product on a specified machine.
- display_schedule/1: Displays the production schedule for a specified machine.
- validate_resource/2: Validates the data for adding a resource.
- validate_product/3: Validates the data for adding a product.
- add_product_ui_action/3: Adds a new product to the system.
# User Interface
- start_interface/0: Initializes and opens the main dialog window.
- display_inventory_ui/0: Displays the current inventory in a dialog.
- display_resources_ui/0: Displays the available resources in a dialog.
- add_resource_ui/0: Opens a dialog to add a new resource.
- add_resource_ui_action/2: Handles the action of adding a resource from the UI.
- produce_product_ui/0: Opens a dialog to produce a product.
- produce_product_ui_action/2: Handles the action of producing a product from the UI.
- schedule_production_ui/0: Opens a dialog to schedule production.
- schedule_production_ui_action/3: Handles the action of scheduling production from the UI.
- add_product_ui/0: Opens a dialog to add a new product.
- get_name_and_time/3: Retrieves the name and time for a new product from the UI.
- create_resource_fields/4: Creates input fields for resource quantities in the add product dialog.
- add_product_ui_action/3: Handles the action of adding a new product from the UI.
- get_values/2: Retrieves the values from input fields.
- create_resources/3: Creates resource structures from input values.

# Example Usage
To add 100 units of wood, you can run the following in the Prolog console:


?- add_resource(wood, 100).
To produce 10 chairs, you can run:


?- produce(chair, 10).
To schedule production of 5 tables on machine1, you can run:

prolog
Skopiuj kod
?- schedule_production(table, 5, machine1).
