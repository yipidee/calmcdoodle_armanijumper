extends Node2D

signal next

var dialogue
var chat1_done = false

func _ready():
	dialogue = Dialogue.Script
	$AudioStreamPlayer.play()
	$Davnet.is_drunk = true


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


func player_notification(notification_text, time):
	$Cal.in_conversation = true
	$Text/CenterContainer/RichTextLabel.text = notification_text
	yield(get_tree().create_timer(time),"timeout")
	$Text/CenterContainer/RichTextLabel.text = ""
	$Cal.in_conversation = false


func _process(delta):
	if not chat1_done:
		if Input.is_action_just_pressed("ui_accept") and $Davnet/DavnetZone.overlaps_body($Cal):
			chat1_done = true
			$Davnet.in_conversation = true
			read_script("glenroe3", $Cal)
	if chat1_done and not $Cal.in_conversation:
		yield(get_tree().create_timer(1.0),"timeout")
		get_tree().change_scene("res://Rainers.tscn")
