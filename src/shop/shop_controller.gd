extends Control
class_name ShopController

signal item_purchased(item: Resource)
signal shop_skipped
signal shop_rerolled(items: Array[Resource], cost: int)

var money: int = 0
var inventory: Array[Resource] = []
var reroll_count: int = 0
var shop_pool: ShopPoolDefinition

func configure(starting_money: int, items: Array[Resource], pool: ShopPoolDefinition = null) -> void:
	money = starting_money
	inventory = items.duplicate()
	shop_pool = pool
	reroll_count = 0

func purchase(item: Resource, price: int) -> bool:
	if price > money or not inventory.has(item):
		return false
	money -= price
	inventory.erase(item)
	item_purchased.emit(item)
	return true

func reroll() -> bool:
	if shop_pool == null:
		return false
	var cost := shop_pool.reroll_cost(reroll_count)
	if money < cost:
		return false
	money -= cost
	reroll_count += 1
	inventory = shop_pool.roll_inventory(reroll_count)
	shop_rerolled.emit(inventory, cost)
	return true

func skip_shop() -> void:
	shop_skipped.emit()
