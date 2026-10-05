class_name CountdownScreen
extends BaseShellScreen

signal completed

var _generation := 0


func _ready() -> void:
	var body := page_vbox()
	body.alignment = BoxContainer.ALIGNMENT_CENTER
	var countdown_label := label("3", 96, HORIZONTAL_ALIGNMENT_CENTER)
	body.add_child(countdown_label)
	_generation += 1
	_run(countdown_label, _generation)


func _exit_tree() -> void:
	_generation += 1


func _run(countdown_label: Label, generation: int) -> void:
	for text_value: String in ["3", "2", "1"]:
		if generation != _generation or not is_instance_valid(countdown_label):
			return
		countdown_label.text = text_value
		await get_tree().create_timer(0.6).timeout
	if generation != _generation or not is_instance_valid(countdown_label):
		return
	countdown_label.text = "PLAY"
	await get_tree().create_timer(0.7).timeout
	if generation == _generation and is_inside_tree():
		completed.emit()
