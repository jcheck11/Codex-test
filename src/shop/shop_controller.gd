extends Control
class_name ShopController

signal item_purchased(item: Resource)
signal shop_skipped

var money: int = 0
var inventory: Array[Resource] = []

func configure(starting_money: int, items: Array[Resource]) -> void:
	money = starting_money
	inventory = items.duplicate()

func purchase(item: Resource, price: int) -> bool:
	if price > money or not inventory.has(item):
		return false
	money -= price
	inventory.erase(item)
	item_purchased.emit(item)
	return true

func skip_shop() -> void:
	shop_skipped.emit()
