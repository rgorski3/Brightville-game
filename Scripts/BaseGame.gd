class_name BaseGame
extends Node2D
## Parent class for every Brightville subgame. Centralizes the PBS Kids-style
## "juice" feedback loop (spec §3) so subgames only describe their own logic.

signal round_succeeded
signal round_failed
signal subgame_completed

const HOME_SCENE := "res://Scenes/MainMenu.tscn"

@export var subgame_id: StringName = &""
@export var rounds_to_badge: int = 3

var _rounds_won: int = 0

func _ready() -> void:
	round_succeeded.connect(_on_round_succeeded)
	round_failed.connect(_on_round_failed)

func report_success() -> void:
	round_succeeded.emit()

func report_failure() -> void:
	round_failed.emit()

func return_to_hub() -> void:
	SceneTransition.change_scene(HOME_SCENE)

func _on_round_succeeded() -> void:
	_rounds_won += 1
	GameState.add_score(subgame_id, 1)
	_play_positive_feedback()
	if _rounds_won >= rounds_to_badge:
		GameState.award_badge(subgame_id)
		subgame_completed.emit()

func _on_round_failed() -> void:
	_play_negative_feedback()

func _play_positive_feedback() -> void:
	# Placeholder for chime + star particles + happy animation.
	# Subclasses override or compose with their own scene nodes.
	pass

func _play_negative_feedback() -> void:
	# Placeholder for "uh-oh" buzzer + item shake.
	pass
