extends BaseGame
## Subgame 3: Grand Brightville Hotel (Front Desk).
## Guest emits a request with 3 ItemIDs; player clicks matching buttons.

signal request_issued(item_ids: Array[StringName])

const LOCATION_INVENTORY := {
	"main_street": [&"towel", &"soap", &"key", &"map", &"lamp", &"mint"],
	"riverbank": [&"canoe", &"fish_rod", &"sun_hat", &"raft", &"picnic", &"bird_book"],
	"sky_high": [&"tuxedo", &"cupcake", &"gold_pen", &"umbrella", &"watch", &"rose"],
}

@export var location: StringName = &"main_street"

@onready var guest_label: Label = %GuestLabel
@onready var request_label: Label = %RequestLabel
@onready var inventory_grid: GridContainer = %InventoryGrid

var _current_request: Array[StringName] = []
var _delivered: Array[StringName] = []
var _button_lookup: Dictionary = {}

func _ready() -> void:
	super()
	subgame_id = GameState.SUBGAME_HOTEL
	_build_inventory()
	_new_request()

func _build_inventory() -> void:
	for child in inventory_grid.get_children():
		child.queue_free()
	_button_lookup.clear()

	var items = LOCATION_INVENTORY.get(location, LOCATION_INVENTORY[&"main_street"])
	for item_id in items:
		var btn := Button.new()
		btn.text = String(item_id).replace("_", " ").capitalize()
		btn.custom_minimum_size = Vector2(320, 200)
		btn.add_theme_font_size_override("font_size", 36)
		btn.pressed.connect(_on_item_pressed.bind(item_id))
		inventory_grid.add_child(btn)
		_button_lookup[item_id] = btn

func _new_request() -> void:
	_delivered.clear()
	var items: Array = LOCATION_INVENTORY.get(location, LOCATION_INVENTORY[&"main_street"]).duplicate()
	items.shuffle()
	_current_request = []
	for i in range(min(3, items.size())):
		_current_request.append(items[i])
	guest_label.text = "Guest: \"Hi! Could you bring me...\""
	_refresh_request_label()
	request_issued.emit(_current_request)

func _refresh_request_label() -> void:
	var remaining: Array[String] = []
	for id in _current_request:
		if id in _delivered:
			remaining.append("[✓] %s" % String(id).replace("_", " "))
		else:
			remaining.append("• %s" % String(id).replace("_", " "))
	request_label.text = "\n".join(remaining)

func _on_item_pressed(item_id: StringName) -> void:
	if item_id in _delivered:
		return
	if item_id in _current_request:
		_delivered.append(item_id)
		_refresh_request_label()
		if _delivered.size() == _current_request.size():
			if report_success():
				return
			_new_request()
	else:
		report_failure()
