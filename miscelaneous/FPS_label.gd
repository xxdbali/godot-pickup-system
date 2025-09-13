extends Label

func _process(_delta: float) -> void:
    # Get the current engine FPS
    var fps = Engine.get_frames_per_second()
    
    # Update the label text
    self.text = "FPS: %d" % fps
