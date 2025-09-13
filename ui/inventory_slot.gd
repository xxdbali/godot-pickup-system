extends Control

func _ready():
    # Defer the initial size calculation until the parent container has a valid size.
    call_deferred("update_size")
    
func _notification(what):
    if what == NOTIFICATION_RESIZED:
        update_size()

func update_size():
    if get_parent():
        # Parent's size should now be correctly determined.
        var parent_size_x = get_parent().size.x
        var new_size = parent_size_x / 12.0
        
        # We set the actual size based on the parent's size.
        set_size(Vector2(new_size, new_size))