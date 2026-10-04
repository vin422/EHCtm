extends CanvasLayer

@onready var hotspot_label: Label = $HotspotLabel

var hotspot_label_tween: Tween


func _ready():
	hotspot_label.hide()


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
