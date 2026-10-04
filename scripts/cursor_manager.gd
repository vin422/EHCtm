extends Node

const DEFAULT_CURSOR = preload("res://assets/cursors/placeholderpointer.png")
const INTERACT_CURSOR = preload("res://assets/cursors/handplaceholder.png")

const DEFAULT_HOTSPOT := Vector2(0, 0)
const INTERACT_HOTSPOT := Vector2(0, 0)

const ITEM_CURSOR_SIZE: int = 48

var carried_item: InventoryItem = null



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
	if carried_item != null:
		return

	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func set_interact_cursor():
	if carried_item != null:
		return

	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func carry_item(item: InventoryItem):
	carried_item = item

	if item.icon == null:
		return

	var image = item.icon.get_image()
	image.resize(
		ITEM_CURSOR_SIZE,
		ITEM_CURSOR_SIZE,
		Image.INTERPOLATE_LANCZOS
	)

	var cursor_texture = ImageTexture.create_from_image(image)

	Input.set_custom_mouse_cursor(
		cursor_texture,
		Input.CURSOR_ARROW,
		Vector2(
			ITEM_CURSOR_SIZE / 2.0,
			ITEM_CURSOR_SIZE / 2.0
		)
	)

	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func stop_carrying_item():
	carried_item = null

	Input.set_custom_mouse_cursor(
		DEFAULT_CURSOR,
		Input.CURSOR_ARROW,
		DEFAULT_HOTSPOT
	)

	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
