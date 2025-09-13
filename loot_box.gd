extends RigidBody3D

const ITEM_NAMES := [
	"Crystal Blade", "Iron Gauntlet", "Phoenix Feather", "Shadow Cloak", "Dragon Scale",
	"Elven Bow", "Soul Lantern", "Bloodstone Amulet", "Thief's Talisman", "Rune Scroll",
	"Flame Dagger", "Storm Orb", "Titan Helm", "Echo Bell", "Ghoul Ring",
	"Sapphire Lens", "Mimic Tooth", "Spirit Charm", "Thunder Rod", "Obsidian Knife",
	"Necro Grimoire", "Moonstone Shard", "Frost Medallion", "Arcane Wand", "Wyrm Horn",
	"Lava Core", "Mystic Coin", "Golden Idol", "Bone Totem", "Vampire Fang",
	"Spectral Key", "Firefly Jar", "Nightshade Gem", "Gravity Pendant", "Warden's Crest",
	"Shaman Mask", "Dusk Mirror", "Whisper Shell", "Amber Crystal", "Ancient Relic",
	"Holy Symbol", "Wolf Totem", "Void Essence", "Witch's Locket", "Chimeric Fur",
	"Tempest Gem", "Ashen Band", "Ice Rose", "Storm Fang", "Runestone Eye"
]

@onready var label := Label3D.new()
var label_color := Color.WHITE
var label_text := ITEM_NAMES[0]

func _ready():
	randomize()

	# Use existing metadata if restoring from inventory
	if not has_meta("item_name"):
		label_text = ITEM_NAMES[randi() % ITEM_NAMES.size()]
		set_meta("item_name", label_text)
	else:
		label_text = get_meta("item_name")

	if not has_meta("item_color"):
		label_color = Color(
			randf_range(0.3, 1.0),
			randf_range(0.3, 1.0),
			randf_range(0.3, 1.0)
		)
		set_meta("item_color", label_color)
	else:
		label_color = get_meta("item_color")

	# Setup label
	label.text = label_text
	label.position = Vector3(0, 1, 0)
	label.modulate = label_color
	label.font_size = 32
	add_child(label)


func _process(_delta):
	var camera = get_viewport().get_camera_3d()
	if camera:
		label.look_at(camera.global_transform.origin, Vector3.UP)
		label.rotate_y(PI) # Flip around Y to face camera correctly
