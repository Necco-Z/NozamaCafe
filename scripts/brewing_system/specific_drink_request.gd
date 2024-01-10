class_name SpecificDrinkRequest
extends DrinkRequest


@export var valid_drinks : Array[DrinkRecipe] = [null]


func try_fulfill_request(drink_to_test : DrinkRecipe) -> bool:
	for each_drink in valid_drinks:
		if each_drink.compare_with(drink_to_test) == true: 
			return true
	
	return false
