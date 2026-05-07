extends CanvasLayer

var overlay: ColorRect

func _ready():
	add_to_group("fade_layer")
	layer = 10
	
	overlay = ColorRect.new()
	overlay.color = Color.BLACK
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	add_child(overlay)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	var t := create_tween()
	t.tween_property(overlay, "color:a", 0.0, 1.0)

func fade_out_and_restart():
	overlay.color.a = 0.0
	
	var t := create_tween()
	t.tween_property(overlay, "color:a", 1.0, 1.5)
	t.tween_callback(func(): get_tree().change_scene_to_file("res://scenes/sheep_minigame.tscn"))
