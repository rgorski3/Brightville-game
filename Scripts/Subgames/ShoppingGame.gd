extends BaseGame
## Subgame 2: Brightville Bazaar.
## One item must cost > player_money, the other <= player_money.
## Player drags the affordable item into the Shopping Bag.

const MIN_WALLET := 5
const MAX_WALLET := 20

@onready var wallet_label: Label = %WalletLabel
@onready var item_a: Control = %ItemA
@onready var item_b: Control = %ItemB
@onready var bag: Control = %ShoppingBag
@onready var price_a_label: Label = %ItemA/PriceLabel
@onready var price_b_label: Label = %ItemB/PriceLabel

var player_money: int = 0
var price_a: int = 0
var price_b: int = 0
var affordable_slot: Control

func _ready() -> void:
	super()
	subgame_id = GameState.SUBGAME_SHOPPING
	bag.set_meta("drop_target", true)
	item_a.gui_input.connect(_on_item_clicked.bind(item_a))
	item_b.gui_input.connect(_on_item_clicked.bind(item_b))
	_new_round()

func _new_round() -> void:
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

func _on_item_clicked(event: InputEvent, slot: Control) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_handle_selection(slot)

func _handle_selection(slot: Control) -> void:
	var price := price_a if slot == item_a else price_b
	if price <= player_money:
		report_success()
		_new_round()
	else:
		report_failure()
