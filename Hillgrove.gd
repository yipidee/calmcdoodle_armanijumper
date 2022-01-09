extends Node2D

signal next

var dialogue
var chat1_done = false
var chat2_done = false
var talked_to_deera = false

func _ready():
	dialogue = Dialogue.Script
	$AudioStreamPlayer.play()


func _input(event):
	if event.is_action_pressed("ui_accept"):
		emit_signal("next")


func read_script(passage, player):
	player.in_conversation = true
	for line in dialogue[passage]:
		$Text/CenterContainer/RichTextLabel.text = line
		yield(self, "next")
	$Text/CenterContainer/RichTextLabel.text = ""
	player.in_conversation = false


func _process(delta):
	if not chat1_done:
		if Input.is_action_just_pressed("ui_accept") and $LadsZone.overlaps_body($Cal):
			chat1_done = true
			read_script("lads1", $Cal)
	if not chat2_done:
		if Input.is_action_just_pressed("ui_accept") and $LadsZone.overlaps_body($Cal) and talked_to_deera:
			chat2_done = true
			read_script("lads2", $Cal)
	if chat2_done and not $Cal.in_conversation:
		yield(get_tree().create_timer(1.0),"timeout")
		get_tree().change_scene("res://Epilogue.tscn")


func _on_RonnellyZone_body_entered(body):
	if body.name == "Cal" and chat1_done and not talked_to_deera:
		$Cal.visible = false
		$AnimationPlayer.play("Fade_in_out")
		yield($AnimationPlayer,"animation_finished")
		$Text/CenterContainer/RichTextLabel.text = "[ Maybe chat to the lads again ]"
		$Cal.position = $Respawn.position
		$Cal.visible = true
		talked_to_deera = true
