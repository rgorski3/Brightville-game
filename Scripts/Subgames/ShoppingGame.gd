extends BaseGame
## Subgame 2: Brightville Bazaar.
## One item must cost > player_money, the other <= player_money.
## Player drags the affordable item into the Shopping Bag.

const MIN_WALLET := 5
const MAX_WALLET := 20

@onready var wallet_label: Label = %WalletLabel
@onready var item_a: ColorRect = %ItemA
@onready var item_b: ColorRect = %ItemB
@onready var bag: ColorRect = %ShoppingBag
@onready var price_a_label: Label = %ItemA/PriceLabel
@onready var price_b_label: Label = %ItemB/PriceLabel

var player_money: int = 0
var price_a: int = 0
var price_b: int = 0
var affordable_slot: Control
var _round_active: bool = true

func _ready() -> void:
	super()
	subgame_id = GameState.SUBGAME_SHOPPING
	# Drag-and-drop wiring per spec §2.2: shelf items are drag sources,
	# the shopping bag is the drop target.
	item_a.set_drag_forwarding(_get_slot_drag_data.bind(item_a), Callable(), Callable())
	item_b.set_drag_forwarding(_get_slot_drag_data.bind(item_b), Callable(), Callable())
	bag.set_drag_forwarding(Callable(), _bag_can_drop, _bag_drop)
	_new_round()

func _new_round() -> void:
	_round_active = true
	player_money = randi_range(MIN_WALLET, MAX_WALLET)
	# Guarantee one affordable and one unaffordable item.
	var affordable_price := randi_range(max(1, player_money - 4), player_money)
	var unaffordable_price := randi_range(player_money + 1, player_money + 6)

	if randf() < 0.5:
		price_a = affordable_price
		price_b = unaffordable_price
		affordable_slot = item_a
	else:
		price_a = unaffordable_price
		price_b = affordable_price
		affordable_slot = item_b

	wallet_label.text = "Wallet: $%d" % player_money
	price_a_label.text = "$%d" % price_a
	price_b_label.text = "$%d" % price_b

func _get_slot_drag_data(slot: ColorRect, _at_position: Vector2) -> Variant:
	if not _round_active:
		return null
	var preview := ColorRect.new()
	preview.color = slot.color
	preview.custom_minimum_size = Vector2(200, 200)
	preview.size = Vector2(200, 200)
	slot.set_drag_preview(preview)
	return slot

func _bag_can_drop(_at_position: Vector2, data: Variant) -> bool:
	return _round_active and (data == item_a or data == item_b)

func _bag_drop(_at_position: Vector2, data: Variant) -> void:
	if not _round_active:
		return
	_handle_selection(data)

func _handle_selection(slot: Control) -> void:
	var price := price_a if slot == item_a else price_b
	if price <= player_money:
		_round_active = false
		if report_success():
			return
		_new_round()
	else:
		report_failure()
