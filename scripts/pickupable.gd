extends RigidBody3D

@export var item_type = ""
@export var item_name = ""
@export var completes_quest_on_pickup: int = -1

var outline_mats: Array = []
var held = false
var placed = false
var orig_layer
var orig_mask
var child_slots: Array = []


func _ready():
	orig_layer = collision_layer
	orig_mask = collision_mask

	for mesh in find_all_meshes(self):
		var mat: ShaderMaterial = load("res://shaders/outline_material.tres").duplicate()
		mesh.material_overlay = mat
		outline_mats.append(mat)
	child_slots = find_all_slots(self)
	set_child_slots_active(false)


func set_hovered(on: bool):
	if held or placed:
		on = false
	for mat in outline_mats:
		mat.set_shader_parameter("active", on)


func find_all_meshes(node: Node) -> Array:
	var result: Array = []
	for child in node.get_children():
		if child is MeshInstance3D:
			result.append(child)
		result.append_array(find_all_meshes(child))
	return result


func interact(_player):
	if placed:
		return
	if held:
		return
	_player.pick_up(self)


func pick_up():
	held = true
	freeze = true
	collision_layer = 0
	collision_mask = 0
	set_child_slots_active(false)
	var sm = get_tree().get_first_node_in_group("sound_manager")
	if sm:
		sm.play_pickup()
	if completes_quest_on_pickup >= 0:
		var qm = get_tree().get_first_node_in_group("quest_manager")
		if qm:
			qm.complete_current(completes_quest_on_pickup)


func drop():
	held = false
	freeze = false
	collision_layer = orig_layer
	collision_mask = orig_mask


func place_at(t: Transform3D):
	held = false
	placed = true
	freeze = true
	collision_layer = 0
	collision_mask = 0
	global_transform = t
	set_child_slots_active(true)


func set_child_slots_active(on: bool):
	for s in child_slots:
		s.set_active(on)


func find_all_slots(node: Node) -> Array:
	var result: Array = []
	for child in node.get_children():
		if child.has_method("set_active") and child.is_in_group("placement_spot"):
			result.append(child)
		result.append_array(find_all_slots(child))
	return result
