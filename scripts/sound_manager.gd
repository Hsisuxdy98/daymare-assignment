extends Node

@onready var ambient_sound: AudioStreamPlayer = $AmbientSound
@onready var alarm_clock_sound: AudioStreamPlayer = $AlarmClockSound
@onready var pickup_sound: AudioStreamPlayer = $PickupSound
@onready var step_sound: AudioStreamPlayer = $StepSound
@onready var door_sound: AudioStreamPlayer = $DoorSound

var quest_manager: Node
var alarm_active := true


func _ready():
	add_to_group("sound_manager")
	await get_tree().process_frame
	ambient_sound.finished.connect(play_ambient)
	alarm_clock_sound.finished.connect(play_alarm_clock)
	quest_manager = get_tree().get_first_node_in_group("quest_manager")
	if quest_manager:
		quest_manager.quest_updated.connect(on_quest_updated)
	play_ambient()
	play_alarm_clock()


func play_ambient():
	if ambient_sound.stream:
		ambient_sound.play()


func play_alarm_clock():
	if alarm_active and alarm_clock_sound.stream:
		alarm_clock_sound.play()


func on_quest_updated():
	if quest_manager.current_index >= 1:
		alarm_active = false
		alarm_clock_sound.stop()


func play_pickup():
	if pickup_sound.stream:
		pickup_sound.play()


func play_step():
	if step_sound.stream:
		step_sound.play()


func play_door():
	if door_sound.stream:
		door_sound.play()
