extends Node2D

@export var spawn_min := 1.2
@export var spawn_max := 2.2
@export var sheep_scene: PackedScene
@export var next_scene_path := "res://scenes/main.tscn"

@onready var spawn_timer: Timer = $SpawnTimer
@onready var count_label: Label = $UI/CountLabel
@onready var fence: Sprite2D = $Fence
@onready var fade_rect: ColorRect = $UI/FadeRect
@onready var play_button: Button = $UI/PlayButton
@onready var ambient_sound: AudioStreamPlayer = $AmbientSound
@onready var jump_sound: AudioStreamPlayer = $JumpSound
@onready var success_sound: AudioStreamPlayer = $SuccessSound
@onready var fail_sound: AudioStreamPlayer = $FailSound

var count := 0
var starting := false
var current_sheep: Node2D = null


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	fade_rect.color.a = 1.0
	var fade_in = create_tween()
	fade_in.tween_property(fade_rect, "color:a", 0.0, 1.0)
	update_label()
	spawn_timer.timeout.connect(spawn_sheep)
	ambient_sound.finished.connect(loop_ambient)
	play_button.pressed.connect(on_play_pressed)
	spawn_sheep()


func loop_ambient():
	ambient_sound.play()


func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and current_sheep:
		if current_sheep.try_jump():
			jump_sound.play()


func start_timer():
	spawn_timer.wait_time = randf_range(spawn_min, spawn_max)
	spawn_timer.start()


func spawn_sheep():
	if starting:
		return
	var sheep = sheep_scene.instantiate()
	add_child(sheep)
	var screen_size = get_viewport_rect().size
	var ground_y = screen_size.y * 0.78
	sheep.setup(Vector2(-150, ground_y), fence.position.x, screen_size.x + 200)
	sheep.jumped.connect(on_sheep_jumped)
	sheep.failed.connect(on_sheep_failed)
	current_sheep = sheep


func on_sheep_jumped():
	current_sheep = null
	count += 1
	update_label()
	success_sound.play()
	start_timer()


func on_sheep_failed():
	current_sheep = null
	fail_sound.play()
	start_timer()


func on_play_pressed():
	if starting:
		return
	starting = true
	play_button.disabled = true
	var fade_out = create_tween()
	fade_out.tween_property(fade_rect, "color:a", 1.0, 1.2)
	fade_out.parallel().tween_property(ambient_sound, "volume_db", -60.0, 1.2)
	await fade_out.finished
	get_tree().change_scene_to_file(next_scene_path)


func update_label():
	count_label.text = str(count)
