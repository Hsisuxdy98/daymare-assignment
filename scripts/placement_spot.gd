extends StaticBody3D

@export var accepts_type = ""
@export var ghost_path: NodePath
@export var requires_filled_path: NodePath
@export var completes_quest_index: int = -1

var outline_mats: Array = []
var placed_item: Node3D = null
var active = true
var consumed = false
var orig_layer: int
var orig_mask: int

@onready var ghost = get_node_or_null(ghost_path)

var ghost_base_scale: Vector3
var ghost_time: float = 0


func _ready():
	add_to_group("placement_spot")
	orig_layer = collision_layer
	orig_mask = collision_mask
	for mesh in find_all_meshes(self):
		var mat: ShaderMaterial = load("res://shaders/outline_material.tres").duplicate()
		mesh.material_overlay = mat
		outline_mats.append(mat)
	if ghost:
		ghost_base_scale = ghost.scale
		ghost.visible = false


func set_hovered(on: bool):
	if consumed or placed_item or not prereq_ok() or not active:
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


func _process(delta):
	if ghost == null:
		return
	var should_show = placed_item == null and prereq_ok() and active and not consumed
	ghost.visible = should_show
	if should_show:
		ghost_time += delta
		var s = 1.0 + 0.1 * sin(ghost_time * 3)
		ghost.scale = ghost_base_scale * s


func interact(player):
	if consumed or placed_item or not prereq_ok() or not active:
		return
	var h = player.held_object
	if h == null:
		return
	if accepts_type != "" and h.get("item_type") != accepts_type:
		return
	player.clear_held()
	h.place_at(global_transform)
	placed_item = h
	#print("placed ", h.item_name)
	if ghost:
		ghost.visible = false
	if completes_quest_index >= 0:
		var qm = get_tree().get_first_node_in_group("quest_manager")
		if qm:
			qm.complete_current(completes_quest_index)


func clear():
	consumed = true
	if ghost:
		ghost.visible = false
	if placed_item == null:
		return
	var p = placed_item
	placed_item = null
	var t = create_tween().set_ease(Tween.EASE_OUT)
	t.tween_property(p, "scale", Vector3.ZERO, 0.4)
	t.tween_callback(func(): p.queue_free())


func is_filled() -> bool:
	return placed_item != null


func set_active(on: bool):
	active = on
	if on:
		collision_layer = orig_layer
		collision_mask = orig_mask
	else:
		collision_layer = 0
		collision_mask = 0


func prereq_ok() -> bool:
	if requires_filled_path.is_empty():
		return true
	var other = get_node_or_null(requires_filled_path)
	return other != null and other.is_filled()
