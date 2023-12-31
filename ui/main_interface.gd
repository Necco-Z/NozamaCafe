extends Control

signal interface_hidden
signal drink_delivered

@export var start_hidden := false

var custom_recipe : Recipe
var tween_time := 0.5

@onready var list := $List as Label
@onready var ingredient_list := $IngredientsBG/Ingredients as Control
@onready var drink_items := $DrinkItems as Control


# built-in
func _ready() -> void:
	if start_hidden:
		anchor_top = -1
		anchor_bottom = 0
	for i in ingredient_list.get_children():
		i.connect("pressed", _on_ingredient_chosen.bind(i.text))
	$StartOver.connect("pressed", _on_start_over)
	$Deliver.connect("pressed", _on_deliver)


# public
func show_interface() -> void:
	var t = create_tween()
	t = t.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	t.tween_property(self, "anchor_top", 0, tween_time)
	t.tween_property(self, "anchor_bottom", 1, tween_time)


func hide_interface() -> void:
	var t = create_tween()
	t = t.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC).set_parallel()
	t.tween_property(self, "anchor_top", -1, tween_time)
	t.tween_property(self, "anchor_bottom", 0, tween_time)
	await t.finished
	interface_hidden.emit()

# private
func _update_drink() -> void:
	if custom_recipe == null:
		list.text = ""
		return

	var ingredients = custom_recipe.list_ingredients()
	var labels = drink_items.get_children()
	for i in range(ingredients.size()):
		labels[i].text = ingredients[i]


# signals
func _on_ingredient_chosen(ingredient := "") -> void:
	if ingredient == "":
		return

	if custom_recipe == null:
		custom_recipe = Recipe.new([ingredient])
	else:
		custom_recipe.add_ingredient(ingredient)
	_update_drink()


func _on_start_over() -> void:
	custom_recipe = null
	_update_drink()


func _on_deliver() -> void:
	if custom_recipe == null:
		return
	var result = Data.compare_recipes(custom_recipe)
	Dialogic.VAR.current_drink = result
	custom_recipe = null
	_update_drink()
	await hide_interface()
	drink_delivered.emit()
