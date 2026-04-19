extends Node2D
## The Brightville city-map hub. Each building is a button that launches a subgame.
## A small badge indicator next to each button reflects GameState progress.

const ROUTES := {
	&"transit":  "res://Scenes/Subgame_Transit.tscn",
	&"shopping": "res://Scenes/Subgame_Shopping.tscn",
	&"hotel":    "res://Scenes/Subgame_Hotel.tscn",
}

@onready var transit_button: Button = $UI/Buttons/TransitButton
@onready var shopping_button: Button = $UI/Buttons/ShoppingButton
@onready var hotel_button: Button = $UI/Buttons/HotelButton

func _ready() -> void:
	transit_button.pressed.connect(_go.bind(&"transit"))
	shopping_button.pressed.connect(_go.bind(&"shopping"))
	hotel_button.pressed.connect(_go.bind(&"hotel"))
	GameState.badge_awarded.connect(_refresh_labels.unbind(1))
	_refresh_labels()

func _refresh_labels() -> void:
	transit_button.text = _label("Brightville Express", &"transit")
	shopping_button.text = _label("Brightville Bazaar", &"shopping")
	hotel_button.text = _label("Grand Brightville Hotel", &"hotel")

func _label(title: String, id: StringName) -> String:
	var star := " ★" if GameState.has_badge(id) else ""
	return "%s%s" % [title, star]

func _go(subgame_id: StringName) -> void:
	SceneTransition.change_scene(ROUTES[subgame_id])
