extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var background: Sprite2D = $Background

@onready var walk_left_limit: Marker2D = $WalkLeftLimit
@onready var walk_right_limit: Marker2D = $WalkRightLimit



func _ready():
	var room_width = background.texture.get_width()
	var room_height = background.texture.get_height()

	player.set_walk_limits(
		walk_left_limit.global_position.x,
		walk_right_limit.global_position.x
	)

	var camera = player.get_node("Camera2D")

	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_right = room_width
	camera.limit_bottom = room_height
	



func _unhandled_input(event):
	if GameUI.current_dialogue != null:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:

			var mouse_position = get_viewport().get_mouse_position()

			if GameUI.get_node("InventoryUI").get_global_rect().has_point(mouse_position):
				return

			if InventoryManager.has_selected_item():
				return

			var mouse_world_x = get_global_mouse_position().x
			player.walk_to_x(mouse_world_x)
