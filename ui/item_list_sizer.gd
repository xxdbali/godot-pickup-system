extends HFlowContainer

func _ready():
    # Defer the initial size calculation until the container has a valid size.
    call_deferred("update_children_size")
    
func _notification(what):
    if what == NOTIFICATION_RESIZED:
        update_children_size()

func update_children_size():
    var parent_size_x = size.x
    
    if parent_size_x > 0:
        var new_size = parent_size_x / 10.0
        
        for child in get_children():
            if child is Control:
                # Crucially, we set the custom minimum size.
                # This is what a container uses to determine the layout size of its children.
                child.set_custom_minimum_size(Vector2(new_size, new_size))
                
                # The container automatically re-sorts its children after their minimum size is updated.
                # We can confirm the new size by printing the child's minimum size.
                print("Child's Minimum Size: ", child.get_minimum_size())
        
        print("Parent's Size: ", parent_size_x)
