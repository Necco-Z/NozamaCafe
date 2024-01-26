extends Control

enum Mode {BASE, ADDITIVES, DELIVER}

signal interface_hidden
signal drink_delivered

@export var start_hidden := false

var current_recipe : DrinkRecipe
var tween_time := 0.5
var current_mode := Mode.BASE:
	set = _set_current_mode

@onready var brewing_items := $BrewingItems as Control
@onready var drink_items := $DrinkBG/DrinkItems as Control
@onready var click_sound := $ClickSound as AudioStreamPlayer


# built-in
func _ready() -> void:
	if start_hidden:
		anchor_top = -1
		anchor_bottom = 0
	for i in brewing_items.get_children():
		i.pressed.connect(_on_ingredient_chosen)
	$DrinkBG/StartOver.pressed.connect(_on_start_over)
	$DrinkBG/Deliver.pressed.connect(_on_deliver)
	_set_current_mode(current_mode)
	_connect_sound_signals()


# public
func show_interface() -> void:
	print("mostrando interface")
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
	var panels = drink_items.get_children()
	if current_recipe == null:
		for i in panels:
			i.ingredient = null
	else:
		var ingredients = current_recipe.list_ingredients()
		for i in range(ingredients.size()):
			panels[i].ingredient = ingredients[i]
	_check_current_mode()


func _check_current_mode() -> void:
	if current_recipe == null or current_recipe.base == null:
		current_mode = Mode.BASE
	elif current_recipe.additives[0] == null or current_recipe.additives[1] == null:
		current_mode = Mode.ADDITIVES
	else:
		current_mode = Mode.DELIVER


func _set_current_mode(mode: Mode) -> void:
	current_mode = mode
	match mode:
		Mode.BASE:
			for i in brewing_items.get_children():
				if not i.ingredient.is_base:
					i.disabled = true
				else:
					i.disabled = false
			%Deliver.disabled = true
			%StartOver.disabled = true
		Mode.ADDITIVES:
			for i in brewing_items.get_children():
				if i.ingredient.is_base and not i.ingredient.can_be_additive:
					i.disabled = true
				else:
					i.disabled = false
			%Deliver.disabled = true
			%StartOver.disabled = false
		Mode.DELIVER:
			for i in brewing_items.get_children():
				i.disabled = true
			%Deliver.disabled = false
			%StartOver.disabled = false


func _connect_sound_signals() -> void:
	for i in brewing_items.get_children():
		i.pressed.connect(_on_button_pressed)
	%Deliver.pressed.connect(_on_button_pressed.bind(null))
	%StartOver.pressed.connect(_on_button_pressed.bind(null))


# signals
func _on_ingredient_chosen(ingredient: Ingredient) -> void:
	if ingredient == null:
		printerr("Ingrediente inválido")
	if current_recipe == null:
		current_recipe = DrinkRecipe.new()
	current_recipe.add_ingredient(ingredient)
	_update_drink()


func _on_start_over() -> void:
	current_recipe = null
	_update_drink()


func _on_deliver() -> void:
	await hide_interface()
	drink_delivered.emit(current_recipe)
	print(current_recipe)
	current_recipe = null


func _on_button_pressed(_discarded_arg) -> void:
	click_sound.play(0.3)