extends Node
## DEPRECATED
## Agora a informação sobre as receitas e ingredientes ficam em GlobalResources


var recipe_dict := {
	"Limão Preto" : ["Café", "Limão"],
	"Café Latte" : ["Café", "Leite", "Leite"],
	"Cappucino" : ["Café", "Leite"],
	"Espresso" : ["Café", "Café", "Café"],
	"Café" : ["Café"],
	"Café de Gengibre" : ["Café", "Gengibre", "Canela"],
	"Chá Verde com Leite" : ["Chá", "Leite", "Leite"],
	"Chá Verde" : ["Chá"],
	"Grinch" : ["Chá", "Canela", "Gengibre"],
	"Shin Genmaicha" : ["Chá", "Chá", "Canela"],
	"Bedchamber" : ["Leite", "Canela", "Mel"],
	"Fragmento Limão" : ["Leite", "Mel", "Limão"],
	"STJ" : ["Leite", "Gengibre", "Mel"],
}
var recipes : Array[Recipe]


func _ready() -> void:
	for i in recipe_dict:
		var r = Recipe.new(recipe_dict[i])
		r.name = i
		recipes.append(r)


func compare_recipes(base: Recipe) -> String:
	var result = ""
	for i in recipes:
		if base.compare_to(i):
			result = i.name
			break
	return result
