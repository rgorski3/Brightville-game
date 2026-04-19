extends BaseGame
## Subgame 1: The Brightville Express.
## Compare bus_time vs. train_time, player picks the faster route,
## then a Sprite2D travels along the chosen Path2D (spec Prompt 3).

const DESTINATIONS := ["Dino-Museum", "Cloud Marble Park", "Sparkle Pier"]
const VEHICLE_TRAVEL_SECONDS := 1.8

@onready var destination_label: Label = $UI/DestinationLabel
@onready var bus_button: Button = $UI/Buttons/BusButton
@onready var train_button: Button = $UI/Buttons/TrainButton
@onready var bus_path: PathFollow2D = $BusPath/BusFollow
@onready var train_path: PathFollow2D = $TrainPath/TrainFollow
@onready var bus_sprite: Sprite2D = $BusPath/BusFollow/BusSprite
@onready var train_sprite: Sprite2D = $TrainPath/TrainFollow/TrainSprite

var bus_time: int = 0
var train_time: int = 0
var round_active: bool = false

func _ready() -> void:
	super()
	subgame_id = GameState.SUBGAME_TRANSIT
	bus_button.pressed.connect(_on_route_selected.bind("bus"))
	train_button.pressed.connect(_on_route_selected.bind("train"))
	_new_round()

func _new_round() -> void:
	bus_path.progress_ratio = 0.0
	train_path.progress_ratio = 0.0
	bus_time = randi_range(5, 20)
	train_time = randi_range(5, 20)
	while train_time == bus_time:
		train_time = randi_range(5, 20)

	destination_label.text = "Get to %s!" % DESTINATIONS.pick_random()
	bus_button.text = "Bus — %d min" % bus_time
	train_button.text = "Train — %d min" % train_time
	round_active = true

func _on_route_selected(route: String) -> void:
	if not round_active:
		return
	round_active = false

	var selected_time := bus_time if route == "bus" else train_time
	var correct := selected_time == min(bus_time, train_time)
	var follow := bus_path if route == "bus" else train_path

	await _animate_vehicle(follow)

	if correct:
		if report_success():
			return
	else:
		report_failure()
	_new_round()

func _animate_vehicle(follow: PathFollow2D) -> void:
	var tween := create_tween()
	tween.tween_property(follow, "progress_ratio", 1.0, VEHICLE_TRAVEL_SECONDS)
	await tween.finished
