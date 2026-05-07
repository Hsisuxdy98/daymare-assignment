extends RigidBody3D

@export var locked := false

var outline_mats: Array = []
var is_open := false

func _ready():
	freeze_mode = RigidBody3D.FREEZE_MODE_KINEMATIC
	freeze = true

	if locked:
		return

	for child in get_children():
		for sub in child.get_children():
			if sub is MeshInstance3D:
				var mat: ShaderMaterial = load("res://shaders/outline_material.tres").duplicate()
				sub.material_overlay = mat
				outline_mats.append(mat)

func set_hovered(on: bool):
	for mat in outline_mats:
		mat.set_shader_parameter("active", on)

func interact(player):
	if locked:
		return

	var sm = get_tree().get_first_node_in_group("sound_manager")
	if sm:
		sm.play_door()
	is_open = !is_open
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	if is_open:
		var local_pos := to_local(player.global_position)
		var open_angle := PI / 2.0 if local_pos.z > 0.0 else -PI / 2.0
		tween.tween_property(self, "rotation:y", open_angle, 0.4)
	else:
		tween.tween_property(self, "rotation:y", 0.0, 0.4)
