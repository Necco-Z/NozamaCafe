extends Node


var ingredients_list := []
var recipes_list := []

# Called when the node enters the scene tree for the first time.
func _ready():
	_load_all_ingredients()
	_load_all_recipes()


func _load_all_ingredients() -> void:
	var paths = _get_all_file_paths("res://data/brewing_system/ingredients")
	for path in paths:
		var ingredient = ResourceLoader.load(path)
		ingredients_list.append(ingredient)


func _load_all_recipes() -> void:
	var paths = _get_all_file_paths("res://data/brewing_system/recipes")
	for path in paths:
		var recipe = ResourceLoader.load(path)
		recipes_list.append(recipe)


func _get_all_file_paths(path: String) -> Array[String]:
	var file_paths: Array[String] = []
	var dir = DirAccess.open(path)
	
	if dir == null:
		push_error("Path \"", path, "\" doesn't exist.")
		return []
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		var file_path = path + "/" + file_name # global path separator, includes Windows
		file_paths.append(file_path)
		file_name = dir.get_next()
	
	return file_paths 
