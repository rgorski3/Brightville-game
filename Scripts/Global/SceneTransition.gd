extends CanvasLayer
## Fade-to-color transition used between every scene change (spec §3 "Transitions").

const FADE_DURATION := 0.35
const FADE_COLOR := Color(0.96, 0.93, 0.85, 1.0)

var _rect: ColorRect

func _ready() -> void:
	layer = 128
	_rect = ColorRect.new()
	_rect.color = FADE_COLOR
	_rect.modulate.a = 0.0
	_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_rect.anchor_right = 1.0
	_rect.anchor_bottom = 1.0
	add_child(_rect)

func change_scene(path: String) -> void:
	await _fade_to(1.0)
	var err := get_tree().change_scene_to_file(path)
	if err != OK:
		push_error("Scene change failed: %s (err=%d)" % [path, err])
	await _fade_to(0.0)

func _fade_to(target_alpha: float) -> void:
	var tween := create_tween()
	tween.tween_property(_rect, "modulate:a", target_alpha, FADE_DURATION)
	await tween.finished
