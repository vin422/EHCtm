extends CanvasLayer

@onready var hotspot_label: Label = $HotspotLabel
@onready var pocket_button: TextureButton = $InventoryUI/PocketButton
@onready var inventory_content: VBoxContainer = $InventoryUI/InventoryContent
@onready var slots: HBoxContainer = $InventoryUI/InventoryContent/Slots
@onready var description_label: Label = $InventoryUI/InventoryContent/DescriptionLabel
@onready var fade_overlay: ColorRect = $FadeOverlay
@onready var dialogue_ui: Control = $DialogueUI
@onready var dialogue_portrait: TextureRect = $DialogueUI/DialoguePanel/Portrait
@onready var dialogue_character_name: Label = $DialogueUI/DialoguePanel/CharacterName
@onready var dialogue_text: RichTextLabel = $DialogueUI/DialoguePanel/DialogueText



var hotspot_label_tween: Tween

var current_dialogue: Dialogue = null
var current_dialogue_line_index: int = 0
var scene_after_dialogue: String = ""


func _ready():
	hotspot_label.hide()
	
	dialogue_ui.hide()

	InventoryManager.inventory_changed.connect(refresh_inventory)
	InventoryManager.selection_changed.connect(_on_inventory_selection_changed)

	pocket_button.pressed.connect(toggle_inventory)

	# Connect hover signals from all 7 inventory slots
	for slot in slots.get_children():
		slot.item_hovered.connect(_on_item_hovered)
		slot.item_unhovered.connect(_on_item_unhovered)

	inventory_content.hide()
	description_label.text = ""

	refresh_inventory()


func _process(_delta):
	if hotspot_label.visible:
		var mouse_position = get_viewport().get_mouse_position()
		var viewport_size = get_viewport().get_visible_rect().size

		var label_position = Vector2(
			mouse_position.x - hotspot_label.size.x / 2.0,
			mouse_position.y - hotspot_label.size.y - 15.0
		)

		label_position.x = clamp(
			label_position.x,
			10.0,
			viewport_size.x - hotspot_label.size.x - 10.0
		)

		label_position.y = clamp(
			label_position.y,
			10.0,
			viewport_size.y - hotspot_label.size.y - 10.0
		)

		hotspot_label.position = label_position


func show_hotspot_name(hotspot_name: String):
	if hotspot_label_tween:
		hotspot_label_tween.kill()

	hotspot_label.text = hotspot_name
	hotspot_label.modulate.a = 0.0
	hotspot_label.show()

	hotspot_label_tween = create_tween()

	hotspot_label_tween.tween_property(
		hotspot_label,
		"modulate:a",
		1.0,
		0.12
	)


func hide_hotspot_name():
	if hotspot_label_tween:
		hotspot_label_tween.kill()

	hotspot_label_tween = create_tween()

	hotspot_label_tween.tween_property(
		hotspot_label,
		"modulate:a",
		0.0,
		0.10
	)

	hotspot_label_tween.tween_callback(hotspot_label.hide)

func toggle_inventory():
	inventory_content.visible = not inventory_content.visible


func refresh_inventory():
	var slot_nodes = slots.get_children()
	var inventory_items = InventoryManager.get_items()
	var selected_item = InventoryManager.get_selected_item()

	for i in range(slot_nodes.size()):
		var slot = slot_nodes[i]

		if i < inventory_items.size():
			var item = inventory_items[i]

			slot.setup(item)
			slot.set_selected(item == selected_item)
		else:
			slot.clear_slot()

func _on_inventory_selection_changed(item: InventoryItem):
	if item == null:
		CursorManager.stop_carrying_item()
	else:
		CursorManager.carry_item(item)

	refresh_inventory()

func _on_item_hovered(item: InventoryItem):
	description_label.text = item.description


func _on_item_unhovered():
	description_label.text = ""

func change_scene_with_fade(scene_path: String):
	var tween = create_tween()

	# Fade to black.
	tween.tween_property(
		fade_overlay,
		"modulate:a",
		1.0,
		0.5
	)

	await tween.finished

	# Change the room while the screen is black.
	get_tree().change_scene_to_file(scene_path)

	# Fade back in.
	tween = create_tween()

	tween.tween_property(
		fade_overlay,
		"modulate:a",
		0.0,
		0.5
	)

	await tween.finished

func show_dialogue_line(line: DialogueLine):
	dialogue_character_name.text = line.speaker_name
	dialogue_text.text = line.text
	dialogue_portrait.texture = line.portrait

	dialogue_ui.show()

func start_dialogue(dialogue: Dialogue, next_scene: String = ""):
	if dialogue == null or dialogue.lines.is_empty():
		return

	current_dialogue = dialogue
	current_dialogue_line_index = 0
	scene_after_dialogue = next_scene

	show_dialogue_line(current_dialogue.lines[current_dialogue_line_index])


func advance_dialogue():
	if current_dialogue == null:
		return

	current_dialogue_line_index += 1

	if current_dialogue_line_index >= current_dialogue.lines.size():
		end_dialogue()
		return

	show_dialogue_line(current_dialogue.lines[current_dialogue_line_index])


func end_dialogue():
	dialogue_ui.hide()

	current_dialogue = null
	current_dialogue_line_index = 0

	var next_scene = scene_after_dialogue
	scene_after_dialogue = ""

	if next_scene != "":
		change_scene_with_fade(next_scene)
	
	
func _on_dialogue_ui_gui_input(event):
	if current_dialogue == null:
		return

	if event.is_action_pressed("left_click"):
		advance_dialogue()
		dialogue_ui.accept_event()
