extends Node2D

signal next

var dialogue
var can_go_outside = false
var chat1_done = false
var chat2_done = false

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


func player_notification(notification_text, time):
	$Cal.in_conversation = true
	$Text/CenterContainer/RichTextLabel.text = notification_text
	yield(get_tree().create_timer(time),"timeout")
	$Text/CenterContainer/RichTextLabel.text = ""
	$Cal.in_conversation = false


func _process(delta):
	#Cal going to door first time
	if not chat1_done:
		$Path2D/PathFollow2D.unit_offset += delta / 15
		if Input.is_action_just_pressed("ui_accept") and $Path2D/PathFollow2D/Davnet/DavnetZone.overlaps_body($Cal):
			chat1_done = true
			$Path2D/PathFollow2D/Davnet.in_conversation = true
			read_script("glenroe1", $Cal)
	elif get_node_or_null("Cal") != null:
		if Input.is_action_just_pressed("ui_accept") and $DoorZone.overlaps_body($Cal):
			$Cal.queue_free()
			$Path2D/PathFollow2D/Davnet.computer_controlled = false
			yield(get_tree().create_timer(0.5),"timeout")
			$Text/CenterContainer/RichTextLabel.text = "[ Phone is ringing! ]"
			$Path2D/PathFollow2D/Davnet.in_conversation = false
	elif get_node_or_null("Cal") == null:
		if Input.is_action_just_pressed("ui_accept") and $PhoneZone.overlaps_body($Path2D/PathFollow2D/Davnet) and not chat2_done:
			chat2_done = true
			read_script("glenroe2", $Path2D/PathFollow2D/Davnet)
	if chat2_done and not $Path2D/PathFollow2D/Davnet.in_conversation:
		yield(get_tree().create_timer(1),"timeout")
		get_tree().change_scene("res://Outside.tscn")
