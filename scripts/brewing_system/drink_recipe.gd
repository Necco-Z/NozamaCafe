@tool
class_name DrinkRecipe
extends Resource

## Os diferentes tipos de erros que uma receita pode ter.
## [code]NULL_BASE[/code]: ingrediente base está vazio.
## [code]BASE_IS_NOT_BASE[/code]: ingrediente que deve ser base tem valor `ìs_base` como falso.
## [code]USING_BASE_AS_ADDITIVE[/code]: uma base diferente da base atual foi inclusa nos aditivos (Leite é uma exceção).
## [code]INCORRECT_AMOUNT_OF_ADDITIVES[/code]: foram incluídos mais ou menos aditivos que a quantidade correta: dois.
enum Errors { NULL_BASE, BASE_IS_NOT_BASE, USING_BASE_AS_ADDITIVE, INCORRECT_AMOUNT_OF_ADDITIVES }
## Semelhante a uma bit-field, esse Dictionary terá uma chave para cada erro detectado.
## Usa os valores do enum Erros como chaves e `true` como o valor de cada chave existente.
var errors = {}

@export var name : String = ""

@export_category("Ingredients")

## O ingrediente líquido base da bebida.
@export var base : Ingredient:
	set(ingredient):
		if not _validate_base(ingredient):
			push_error("Base ingredient in recipe \"%s\" must have `is_base` set to true." % name)
		base = ingredient

## Os ingredientes adicionais fora a base da bebida.
## Não é possível incluir ingredientes base, a não ser que sejam o mesmo
## da base da bebida, ou ingredientes como o Leite.
## A ordem não importa.
@export var additives : Array[Ingredient] = []:
	set(array):
		_validate_additives(array)


func _validate_base(base_ingredient:Ingredient) -> bool:
	var invalid := false
	
	if base_ingredient == null:
		errors[Errors.NULL_BASE] = true
		invalid = true
	elif not base_ingredient.is_base:
		errors[Errors.BASE_IS_NOT_BASE] = true
		invalid = true
	
	return (not invalid)


func _validate_additives(additives_array:Array[Ingredient]) -> bool:
	var invalid := false
	
	if additives_array.size() != 2:
		errors[Errors.INCORRECT_AMOUNT_OF_ADDITIVES] = true
		invalid = true
	
	for ingredient in additives_array:
		# leite pode ser usado como aditivo
		if ingredient.is_milk: continue
		# testar se outra base foi incluída
		if ingredient.is_base:
			if ingredient != base:
				errors[Errors.USING_BASE_AS_ADDITIVE] = true
				invalid == true
	
	return (not invalid)




