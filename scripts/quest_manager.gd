extends Node

signal quest_updated

const QUESTS = [
	"Disable the alarm",
	"Go to the kitchen",
	"Find the frying pan",
	"Place the pan on the stove",
	"Find an egg",
	"Place the egg in the pan",
	"Cook the egg",
	"Leave the house"
]

var current_index = 0
var pending: Dictionary = {}


func _ready():
	add_to_group("quest_manager")


func complete_current(quest_index):
	if quest_index < current_index:
		return
	if quest_index > current_index:
		pending[quest_index] = true
		return
	current_index += 1
	while pending.has(current_index):
		pending.erase(current_index)
		current_index += 1
	quest_updated.emit()


func get_quests_to_show() -> Array:
	var result = []
	for i in current_index:
		result.append({"text": QUESTS[i], "done": true})
	if current_index < QUESTS.size():
		result.append({"text": QUESTS[current_index], "done": false})
	return result
