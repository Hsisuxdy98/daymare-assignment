extends StaticBody3D

@export var quest_index = 0
@export var requires_filled_path: NodePath
@export var clear_slots_on_complete: Array = []

var outline_mats: Array = []


func _ready():
	for mesh in find_meshes(self):
		var mat: ShaderMaterial = load("res://shaders/outline_material.tres").duplicate()
		mesh.material_overlay = mat
		outline_mats.append(mat)


func set_hovered(on: bool):
	if not is_current_quest() or not prereq_ok():
		on = false
	for mat in outline_mats:
		mat.set_shader_parameter("active", on)


func find_meshes(node: Node) -> Array:
	for child in node.get_children():
		if child is MeshInstance3D:
			return [child]
		var found = find_meshes(child)
		if found:
			return found
	return []


func interact(_player):
	if not is_current_quest():
		return
	if not prereq_ok():
		return
	var qm = get_tree().get_first_node_in_group("quest_manager")
	if qm:
		qm.complete_current(quest_index)
	for path in clear_slots_on_complete:
		var slot = get_node_or_null(path)
		if slot and slot.has_method("clear"):
			slot.clear()


func is_current_quest() -> bool:
	var qm = get_tree().get_first_node_in_group("quest_manager")
	return qm != null and qm.current_index == quest_index


func prereq_ok() -> bool:
	if requires_filled_path.is_empty():
		return true
	var other = get_node_or_null(requires_filled_path)
	return other != null and other.is_filled()
