extends Node
## Autoload singleton that tracks subgame badges, scores, and hub progress.
## Implements Prompt 1 from brightville_spec.md.

signal badge_awarded(subgame_id: StringName)
signal score_changed(subgame_id: StringName, new_score: int)

const SUBGAME_TRANSIT := &"transit"
const SUBGAME_SHOPPING := &"shopping"
const SUBGAME_HOTEL := &"hotel"

const ALL_SUBGAMES: Array[StringName] = [
	SUBGAME_TRANSIT,
	SUBGAME_SHOPPING,
	SUBGAME_HOTEL,
]

var badges: Dictionary = {}
var scores: Dictionary = {}

func _ready() -> void:
	reset()

func reset() -> void:
	badges.clear()
	scores.clear()
	for id in ALL_SUBGAMES:
		badges[id] = false
		scores[id] = 0

func award_badge(subgame_id: StringName) -> void:
	if not badges.has(subgame_id):
		push_warning("Unknown subgame id: %s" % subgame_id)
		return
	if badges[subgame_id]:
		return
	badges[subgame_id] = true
	badge_awarded.emit(subgame_id)

func has_badge(subgame_id: StringName) -> bool:
	return badges.get(subgame_id, false)

func add_score(subgame_id: StringName, delta: int) -> void:
	if not scores.has(subgame_id):
		push_warning("Unknown subgame id: %s" % subgame_id)
		return
	scores[subgame_id] += delta
	score_changed.emit(subgame_id, scores[subgame_id])

func total_badges() -> int:
	var count := 0
	for id in ALL_SUBGAMES:
		if badges[id]:
			count += 1
	return count

func all_badges_earned() -> bool:
	return total_badges() == ALL_SUBGAMES.size()
