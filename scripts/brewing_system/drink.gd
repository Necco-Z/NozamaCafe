class_name Drink
extends Object


var name := ""
var ingredients : Array[Ingredient] = []
var original_recipe : DrinkRecipe = null


## Faz uma bebida a partir de uma receita. Pode ser comparado à receita depois.
func make_from_recipe(recipe : DrinkRecipe):
	ingredients.append(recipe.base)
	ingredients.append_array(recipe.additives.duplicate())
	name = recipe.name
	original_recipe = recipe


## Faz uma bebida genérica usando os três ingredientes. Não é atrelado a nenhuma receita.
func make_from_ingredients(base:Ingredient, ing1:Ingredient, ing2:Ingredient):
	ingredients = [base, ing1, ing2]
	name = "Drink"
	original_recipe = null


## Retorna todos os Aspectos de Sabor da bebida, na forma da soma dos aspectos
## de cada ingrediente.
func get_aspects() -> Dictionary:
	# sweet, bitter, smooth, warm, fresh
	var flavor_array = [0,0,0,0,0]
	for ingredient in ingredients:
		flavor_array[0] += ingredient.flavor_sweet
		flavor_array[1] += ingredient.flavor_bitter
		flavor_array[2] += ingredient.flavor_smooth
		flavor_array[3] += ingredient.flavor_warm
		flavor_array[4] += ingredient.flavor_fresh
	return {
			"sweet": flavor_array[0],
			"bitter": flavor_array[1],
			"smooth": flavor_array[2],
			"warm": flavor_array[3],
			"fresh": flavor_array[4]
	}


func _to_string():
	return "%s: [%s, %s, %s]" % [name, ingredients[0].name, ingredients[1].name, ingredients[2].name]
