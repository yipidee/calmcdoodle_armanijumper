extends CanvasLayer

signal next
signal script_complete

const PROGRESSION = ["Stef_Walk", "Mitch_Walk", "Stef_Walk", "Mitch_Walk", "Cal_Walk"]

var dialogue


func _ready():
	dialogue = Dialogue.Script
	$AudioStreamPlayer.play()
	run_epilogue()


func run_epilogue():
	var i = 1
	for state in PROGRESSION:
		$AnimationPlayer.play(state)
		read_script("epi" + str(i))
		yield(self, "script_complete")
		i += 1
	yield(get_tree().create_timer(1.0),"timeout")
	get_tree().change_scene("res://Intro.tscn")


func _input(event):
	if event.is_action_pressed("ui_accept"):
		emit_signal("next")


func read_script(passage):
	for line in dialogue[passage]:
		$VBoxContainer/HBoxContainer/Label.text = line
		yield(self, "next")
	#$VBoxContainer/HBoxContainer/Label.text = ""
	emit_signal("script_complete")
