extends Node2D

signal jumped
signal failed

@export var speed := 220.0
@export var jump_speed_multiplier := 1.8
@export var jump_height := 220.0
@export var jump_duration := 0.7
@export var wobble_amplitude := 0.18
@export var wobble_speed := 7.0
@export var fence_half_width := 55.0

var fence_x := 0.0
var ground_y := 0.0
var max_x := 1500.0
var is_jumping := false
var is_falling := false
var passed_fence := false
var time_alive := 0.0

@onready var sprite: Sprite2D = $Sprite2D


func setup(start_pos: Vector2, fence_position_x: float, right_edge: float):
	position = start_pos
	ground_y = start_pos.y
	fence_x = fence_position_x
	max_x = right_edge


func _process(delta):
	if is_falling:
		return
	time_alive += delta
	if not is_jumping:
		sprite.rotation = sin(time_alive * wobble_speed) * wobble_amplitude
	var current_speed = speed
	if is_jumping:
		current_speed = speed * jump_speed_multiplier
	position.x += current_speed * delta
	if not passed_fence and not is_jumping and abs(position.x - fence_x) < fence_half_width:
		fall()
		return
	if not passed_fence and position.x > fence_x + fence_half_width:
		passed_fence = true
		jumped.emit()
	if position.x > max_x:
		queue_free()


func try_jump() -> bool:
	if is_jumping or is_falling or passed_fence:
		return false
	is_jumping = true
	sprite.rotation = 0.0
	var t = create_tween()
	t.tween_property(self, "position:y", ground_y - jump_height, jump_duration * 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	t.tween_property(self, "position:y", ground_y, jump_duration * 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	t.tween_callback(end_jump)
	return true


func end_jump():
	is_jumping = false


func fall():
	is_falling = true
	failed.emit()
	var t = create_tween()
	t.set_parallel(true)
	t.tween_property(self, "position:y", ground_y + 900, 1.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	t.tween_property(self, "rotation", PI, 1.2)
	await t.finished
	queue_free()
