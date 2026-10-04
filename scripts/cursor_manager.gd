extends Node

const DEFAULT_CURSOR = preload("res://assets/cursors/placeholderpointer.png")
const INTERACT_CURSOR = preload("res://assets/cursors/handplaceholder.png")

const DEFAULT_HOTSPOT := Vector2(0, 0)
const INTERACT_HOTSPOT := Vector2(0, 0)


func _ready():
	Input.set_custom_mouse_cursor(
		DEFAULT_CURSOR,
		Input.CURSOR_ARROW,
		DEFAULT_HOTSPOT
	)

	Input.set_custom_mouse_cursor(
		INTERACT_CURSOR,
		Input.CURSOR_POINTING_HAND,
		INTERACT_HOTSPOT
	)

	set_default_cursor()


func set_default_cursor():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func set_interact_cursor():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
