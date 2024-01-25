@tool
extends Container

signal pressed

@export var ingredient: Ingredient:
	set = _set_ingredient
@export_range(0, 20, 1, "or_greater", "suffix:px") var icon_margin := 5:
	set = _set_icon_margin
@export var disabled = false:
	set = _set_disabled
#@export_group("Images", "image_")
#@export var image_normal: Texture2D:
	#set = _set_image_normal
#@export var image_hover: Texture2D
#@export var image_pressed: Texture2D
#@export var image_disabled: Texture2D


func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		fit_child_in_rect(%Button, Rect2(Vector2(), size))
		_set_image_size()


# Setters e getters
func _set_ingredient(value: Ingredient) -> void:
	ingredient = value
	if ingredient != null:
		if ingredient.icon != null:
			%Button.text = ""
			%Icon.texture = ingredient.icon
		else:
			%Button.text = ingredient.name
			%Icon.texture = null
	else:
		%Button.text = ""
		%Icon.texture = null
		queue_sort()


func _set_disabled(value: bool) -> void:
	disabled = value
	%Button.disabled = value


#func _set_image_normal(value: Texture2D) -> void:
	#image_normal = value
	#if value:
		#%Button.text = ""
	#else:
		#%Button.text = ingredient.name
	#%Icon.texture = value
	#queue_sort()


func _set_icon_margin(value: int) -> void:
	value = max(0, value)
	icon_margin = value
	queue_sort()


func _set_image_size() -> void:
	if not %Icon.texture:
		return
	var image_rect := Rect2()
	var texture_size = %Icon.texture.get_size()
	var proportions = (size - Vector2(icon_margin * 2, icon_margin * 2)) / texture_size
	var scale_factor = min(proportions.x, proportions.y)
	image_rect.size = texture_size * scale_factor
	image_rect.position.y = size.y - image_rect.size.y - icon_margin
	image_rect.position.x = (size.x - image_rect.size.x) / 2
	fit_child_in_rect(%Icon, image_rect)


func _on_button_pressed() -> void:
	pressed.emit(ingredient)


#func _on_mouse_entered() -> void:
	#if image_hover:
		#%Icon.texture = image_hover
		#queue_sort()


#func _on_mouse_exited() -> void:
	#if image_normal:
		#%Icon.texture = image_normal
		#queue_sort()


#func _on_button_down() -> void:
	#if image_pressed:
		#%Icon.texture = image_pressed
		#queue_sort()
