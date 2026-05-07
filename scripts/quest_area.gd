extends Area3D

@export var quest_index := 0
@export var fade_on_complete := false

func _ready():
	body_entered.connect(on_body_entered)

func on_body_entered(body: Node):
	if not body is CharacterBody3D:
		return
	var qm = get_tree().get_first_node_in_group("quest_manager")
	if qm == null:
		return
	if qm.current_index != quest_index:
		return
	qm.complete_current(quest_index)
	if fade_on_complete:
		var fade = get_tree().get_first_node_in_group("fade_layer")
		if fade:
			fade.fade_out_and_restart()
