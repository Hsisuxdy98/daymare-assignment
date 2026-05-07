extends CharacterBody3D

var move_speed = 5.0
var test_speed = 10
var mouse_sensitivity = 0.0025

@onready var head = $Head
@onready var interact_ray = $Head/Camera3D/InteractRay
@onready var hold_position = $Head/Camera3D/HoldPosition

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var pitch: float = 0.0
var held_object = null
var current_hover = null
var step_interval := 0.45
var step_timer := 0.0


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		pitch = clamp(pitch - event.relative.y * mouse_sensitivity, deg_to_rad(-85), deg_to_rad(85))
		head.rotation.x = pitch
		return

	if event.is_action_pressed("interact"):
		handle_interact()
	if event.is_action_pressed("drop"):
		drop()
	if event.is_action_pressed("restart"):
		restart()

func _physics_process(delta: float):
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0

	var iv = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var d = (transform.basis * Vector3(iv.x, 0, iv.y)).normalized()

	if d != Vector3.ZERO:
		velocity.x = d.x * move_speed
		velocity.z = d.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)

	move_and_slide()
	update_hover()
	update_steps(delta)

	if held_object:
		held_object.global_transform = hold_position.global_transform

func update_steps(delta: float):
	var horizontal_speed = Vector2(velocity.x, velocity.z).length()
	if is_on_floor() and horizontal_speed > 1.0:
		step_timer -= delta
		if step_timer <= 0.0:
			step_timer = step_interval
			var sm = get_tree().get_first_node_in_group("sound_manager")
			if sm:
				sm.play_step()
	else:
		step_timer = 0.0


func update_hover():
	var t = raycast_find("set_hovered")
	if t == current_hover:
		return
	if current_hover:
		current_hover.set_hovered(false)
	current_hover = t
	if t:
		t.set_hovered(true)

func pick_up(obj):
	if held_object:
		return
	held_object = obj
	obj.pick_up()

func clear_held():
	held_object = null

func handle_interact():
	var t = raycast_find("interact")
	if t:
		t.interact(self)

func drop():
	if held_object == null:
		return
	held_object.global_transform = hold_position.global_transform
	held_object.drop()
	held_object = null

func restart():
	get_tree().change_scene_to_file("res://scenes/sheep_minigame.tscn")

func raycast_find(method_name):
	if not interact_ray.is_colliding():
		return null
	var n = interact_ray.get_collider()
	if n and n.has_method(method_name):
		return n
	return null
