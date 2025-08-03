extends RichTextLabel

func _process(_delta):
	text = " collected: " + str(len(Global.orbs_collected)) + "/" + str(Global.current_orb_id+1)
