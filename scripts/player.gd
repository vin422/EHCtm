extends CharacterBody2D

@export var item_reactions: Array[ItemReaction] = []
@export var speed: float = 700.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var target_x: float
var moving_to_target: bool = false

var min_x: float
var max_x: float

var pending_interactable: Area2D = null


func _ready():
	target_x = global_position.x


func _physics_process(delta):
	var keyboard_direction = Input.get_axis("move_left", "move_right")


	# ----------------------------------------
	# KEYBOARD MOVEMENT
	# ----------------------------------------

	if keyboard_direction != 0.0:
		# Keyboard input cancels click-to-walk
		# and any pending hotspot interaction.
		moving_to_target = false
		pending_interactable = null

		var movement = keyboard_direction * speed * delta

		global_position.x = clamp(
			global_position.x + movement,
			min_x,
			max_x
		)

		animated_sprite.flip_h = keyboard_direction < 0.0
		animated_sprite.play("walk")

		return


	# ----------------------------------------
	# CLICK-TO-WALK MOVEMENT
	# ----------------------------------------

	if moving_to_target:
		var difference = target_x - global_position.x
		var movement = speed * delta

		# We are close enough to reach the destination
		# during this frame.
		if abs(difference) <= movement:
			global_position.x = target_x
			moving_to_target = false

			animated_sprite.play("idle")

			# If this movement was caused by clicking
			# a hotspot, interact now that Lea has arrived.
			if pending_interactable != null:
				var hotspot = pending_interactable
				pending_interactable = null
				hotspot.interact()

			return

		# Continue walking toward the destination.
		var direction = sign(difference)

		global_position.x += direction * movement

		animated_sprite.flip_h = direction < 0.0
		animated_sprite.play("walk")

		return


	# ----------------------------------------
	# IDLE
	# ----------------------------------------

	animated_sprite.play("idle")


# ----------------------------------------
# WALK TO AN ORDINARY POINT
# ----------------------------------------

func walk_to_x(new_target_x: float):
	# Clicking somewhere else cancels a previously
	# requested hotspot interaction.
	pending_interactable = null

	target_x = clamp(
		new_target_x,
		min_x,
		max_x
	)

	moving_to_target = true


# ----------------------------------------
# WALK TO AN INTERACTABLE THINGY
# ----------------------------------------

func move_to_interactable(interactable: Area2D):
	target_x = clamp(
		interactable.interaction_point.global_position.x,
		min_x,
		max_x
	)

	pending_interactable = interactable
	moving_to_target = true


# ----------------------------------------
# SET ROOM WALKING BOUNDARIES
# ----------------------------------------

func set_walk_limits(left: float, right: float):
	min_x = left
	max_x = right

	target_x = clamp(
		target_x,
		min_x,
		max_x
	)

	global_position.x = clamp(
		global_position.x,
		min_x,
		max_x
	)


func _on_item_use_area_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("left_click"):
		if InventoryManager.has_selected_item():
			InventoryManager.use_selected_item_on(self)
			
func use_item(item: InventoryItem):
	for reaction in item_reactions:
		if reaction.item_id == item.id:
			_trigger_item_reaction(reaction)
			return

	print("Can't use ", item.display_name, " on Lea.")

func _trigger_item_reaction(reaction: ItemReaction):
	print("Triggered action: ", reaction.action_id)

	if reaction.consume_item:
		InventoryManager.remove_item(reaction.item_id)

	InventoryManager.clear_selection()
