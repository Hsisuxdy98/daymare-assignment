extends PanelContainer

const QUEST_THEME = preload("res://theme.tres")

@onready var quest_list: VBoxContainer = $VBoxContainer
var quest_manager: Node


func _ready():
	await get_tree().process_frame
	quest_manager = get_tree().get_first_node_in_group("quest_manager")
	if quest_manager:
		quest_manager.quest_updated.connect(rebuild)
	rebuild()


func rebuild():
	for child in quest_list.get_children():
		child.queue_free()
	if quest_manager == null:
		return
	for quest in quest_manager.get_quests_to_show():
		var label := Label.new()
		label.theme = QUEST_THEME
		label.text = ("[✓] " if quest.done else "[ ] ") + quest.text
		label.add_theme_font_size_override("font_size", 15)
		label.add_theme_color_override("font_color", Color.WHITE)
		quest_list.add_child(label)
