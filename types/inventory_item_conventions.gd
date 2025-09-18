extends Resource
class_name InventoryItemConventions
enum Rarity {COMMON, UNCOMMON, RARE, EPIC, LEGENDARY}
enum ItemID {
	CRYSTAL_BLADE,
	IRON_GAUNTLET,
	PHOENIX_FEATHER,
	SHADOW_CLOAK,
	DRAGON_SCALE,
	ELVEN_BOW,
	SOUL_LANTERN,
	BLOODSTONE_AMULET,
	THIEFS_TALISMAN,
	RUNE_SCROLL,
	FLAME_DAGGER,
	STORM_ORB,
	TITAN_HELM,
	ECHO_BELL,
	GHOUL_RING,
	SAPPHIRE_LENS,
	MIMIC_TOOTH,
	SPIRIT_CHARM,
	THUNDER_ROD,
	OBSIDIAN_KNIFE,
	NECRO_GRIMOIRE,
	MOONSTONE_SHARD,
	FROST_MEDALLION,
	ARCANE_WAND,
	WYRM_HORN,
	LAVA_CORE,
	MYSTIC_COIN,
	GOLDEN_IDOL,
	BONE_TOTEM,
	VAMPIRE_FANG,
	SPECTRAL_KEY,
	FIREFLY_JAR,
	NIGHTSHADE_GEM,
	GRAVITY_PENDANT,
	WARDENS_CREST,
	SHAMAN_MASK,
	DUSK_MIRROR,
	WHISPER_SHELL,
	AMBER_CRYSTAL,
	ANCIENT_RELIC,
	HOLY_SYMBOL,
	WOLF_TOTEM,
	VOID_ESSENCE,
	WITCHS_LOCKET,
	CHIMERIC_FUR,
	TEMPEST_GEM,
	ASHEN_BAND,
	ICE_ROSE,
	STORM_FANG,
	RUNESTONE_EYE,
}

# Array of enum values for easy random selection
const ITEM_ID_LIST := [
	ItemID.CRYSTAL_BLADE, ItemID.IRON_GAUNTLET, ItemID.PHOENIX_FEATHER, ItemID.SHADOW_CLOAK, ItemID.DRAGON_SCALE,
	ItemID.ELVEN_BOW, ItemID.SOUL_LANTERN, ItemID.BLOODSTONE_AMULET, ItemID.THIEFS_TALISMAN, ItemID.RUNE_SCROLL,
	ItemID.FLAME_DAGGER, ItemID.STORM_ORB, ItemID.TITAN_HELM, ItemID.ECHO_BELL, ItemID.GHOUL_RING,
	ItemID.SAPPHIRE_LENS, ItemID.MIMIC_TOOTH, ItemID.SPIRIT_CHARM, ItemID.THUNDER_ROD, ItemID.OBSIDIAN_KNIFE,
	ItemID.NECRO_GRIMOIRE, ItemID.MOONSTONE_SHARD, ItemID.FROST_MEDALLION, ItemID.ARCANE_WAND, ItemID.WYRM_HORN,
	ItemID.LAVA_CORE, ItemID.MYSTIC_COIN, ItemID.GOLDEN_IDOL, ItemID.BONE_TOTEM, ItemID.VAMPIRE_FANG,
	ItemID.SPECTRAL_KEY, ItemID.FIREFLY_JAR, ItemID.NIGHTSHADE_GEM, ItemID.GRAVITY_PENDANT, ItemID.WARDENS_CREST,
	ItemID.SHAMAN_MASK, ItemID.DUSK_MIRROR, ItemID.WHISPER_SHELL, ItemID.AMBER_CRYSTAL, ItemID.ANCIENT_RELIC,
	ItemID.HOLY_SYMBOL, ItemID.WOLF_TOTEM, ItemID.VOID_ESSENCE, ItemID.WITCHS_LOCKET, ItemID.CHIMERIC_FUR,
	ItemID.TEMPEST_GEM, ItemID.ASHEN_BAND, ItemID.ICE_ROSE, ItemID.STORM_FANG, ItemID.RUNESTONE_EYE
]

# Optional high-level category for items
enum Category {WEAPON, ARMOR, CONSUMABLE, MATERIAL, RELIC, ACCESSORY, MAGIC, KEY_ITEM, OTHER}

# Base specs: dictionary keyed by ItemID -> InventoryItemBase instance
static var ITEM_SPEC_DATA: Dictionary[int, InventoryItemBase] = {
	ItemID.CRYSTAL_BLADE: InventoryItemBase.new(ItemID.CRYSTAL_BLADE, "Crystal Blade", false, 1, Category.WEAPON, Rarity.RARE, "res://interactive_items/icons/wood.png"),
	ItemID.IRON_GAUNTLET: InventoryItemBase.new(ItemID.IRON_GAUNTLET, "Iron Gauntlet", false, 1, Category.ARMOR, Rarity.UNCOMMON, "res://interactive_items/icons/wood.png"),
	ItemID.PHOENIX_FEATHER: InventoryItemBase.new(ItemID.PHOENIX_FEATHER, "Phoenix Feather", true, 10, Category.CONSUMABLE, Rarity.RARE, "res://interactive_items/icons/wood.png"),
	ItemID.SHADOW_CLOAK: InventoryItemBase.new(ItemID.SHADOW_CLOAK, "Shadow Cloak", false, 1, Category.ARMOR, Rarity.EPIC, "res://interactive_items/icons/wood.png"),
	ItemID.DRAGON_SCALE: InventoryItemBase.new(ItemID.DRAGON_SCALE, "Dragon Scale", true, 50, Category.MATERIAL, Rarity.RARE, "res://interactive_items/icons/wood.png"),
	ItemID.ELVEN_BOW: InventoryItemBase.new(ItemID.ELVEN_BOW, "Elven Bow", false, 1, Category.WEAPON, Rarity.RARE, "res://interactive_items/icons/wood.png"),
	ItemID.SOUL_LANTERN: InventoryItemBase.new(ItemID.SOUL_LANTERN, "Soul Lantern", false, 1, Category.ACCESSORY, Rarity.RARE, "res://interactive_items/icons/wood.png"),
	ItemID.BLOODSTONE_AMULET: InventoryItemBase.new(ItemID.BLOODSTONE_AMULET, "Bloodstone Amulet", false, 1, Category.ACCESSORY, Rarity.EPIC, "res://interactive_items/icons/wood.png"),
	ItemID.THIEFS_TALISMAN: InventoryItemBase.new(ItemID.THIEFS_TALISMAN, "Thief's Talisman", false, 1, Category.ACCESSORY, Rarity.UNCOMMON, "res://interactive_items/icons/wood.png"),
	ItemID.RUNE_SCROLL: InventoryItemBase.new(ItemID.RUNE_SCROLL, "Rune Scroll", true, 50, Category.CONSUMABLE, Rarity.UNCOMMON, "res://interactive_items/icons/wood.png"),
	ItemID.FLAME_DAGGER: InventoryItemBase.new(ItemID.FLAME_DAGGER, "Flame Dagger", false, 1, Category.WEAPON, Rarity.UNCOMMON, "res://interactive_items/icons/wood.png"),
	ItemID.STORM_ORB: InventoryItemBase.new(ItemID.STORM_ORB, "Storm Orb", false, 1, Category.MAGIC, Rarity.RARE, "res://interactive_items/icons/wood.png"),
	ItemID.TITAN_HELM: InventoryItemBase.new(ItemID.TITAN_HELM, "Titan Helm", false, 1, Category.ARMOR, Rarity.RARE, "res://interactive_items/icons/wood.png"),
	ItemID.ECHO_BELL: InventoryItemBase.new(ItemID.ECHO_BELL, "Echo Bell", false, 1, Category.ACCESSORY, Rarity.UNCOMMON, "res://interactive_items/icons/wood.png"),
	ItemID.GHOUL_RING: InventoryItemBase.new(ItemID.GHOUL_RING, "Ghoul Ring", false, 1, Category.ACCESSORY, Rarity.RARE, "res://interactive_items/icons/wood.png"),
	ItemID.SAPPHIRE_LENS: InventoryItemBase.new(ItemID.SAPPHIRE_LENS, "Sapphire Lens", false, 1, Category.ACCESSORY, Rarity.RARE, "res://interactive_items/icons/wood.png"),
	ItemID.MIMIC_TOOTH: InventoryItemBase.new(ItemID.MIMIC_TOOTH, "Mimic Tooth", true, 25, Category.MATERIAL, Rarity.UNCOMMON, "res://interactive_items/icons/wood.png"),
	ItemID.SPIRIT_CHARM: InventoryItemBase.new(ItemID.SPIRIT_CHARM, "Spirit Charm", false, 1, Category.ACCESSORY, Rarity.RARE, "res://interactive_items/icons/wood.png"),
	ItemID.THUNDER_ROD: InventoryItemBase.new(ItemID.THUNDER_ROD, "Thunder Rod", false, 1, Category.MAGIC, Rarity.RARE, "res://interactive_items/icons/wood.png"),
	ItemID.OBSIDIAN_KNIFE: InventoryItemBase.new(ItemID.OBSIDIAN_KNIFE, "Obsidian Knife", false, 1, Category.WEAPON, Rarity.UNCOMMON, "res://interactive_items/icons/wood.png"),
	ItemID.NECRO_GRIMOIRE: InventoryItemBase.new(ItemID.NECRO_GRIMOIRE, "Necro Grimoire", false, 1, Category.MAGIC, Rarity.EPIC, "res://interactive_items/icons/wood.png"),
	ItemID.MOONSTONE_SHARD: InventoryItemBase.new(ItemID.MOONSTONE_SHARD, "Moonstone Shard", true, 99, Category.MATERIAL, Rarity.UNCOMMON, "res://interactive_items/icons/wood.png"),
	ItemID.FROST_MEDALLION: InventoryItemBase.new(ItemID.FROST_MEDALLION, "Frost Medallion", false, 1, Category.ACCESSORY, Rarity.RARE, "res://interactive_items/icons/wood.png"),
	ItemID.ARCANE_WAND: InventoryItemBase.new(ItemID.ARCANE_WAND, "Arcane Wand", false, 1, Category.MAGIC, Rarity.RARE, "res://interactive_items/icons/wood.png"),
	ItemID.WYRM_HORN: InventoryItemBase.new(ItemID.WYRM_HORN, "Wyrm Horn", true, 40, Category.MATERIAL, Rarity.RARE, "res://interactive_items/icons/wood.png"),
	ItemID.LAVA_CORE: InventoryItemBase.new(ItemID.LAVA_CORE, "Lava Core", true, 30, Category.MATERIAL, Rarity.RARE, "res://interactive_items/icons/wood.png"),
	ItemID.MYSTIC_COIN: InventoryItemBase.new(ItemID.MYSTIC_COIN, "Mystic Coin", true, 999, Category.MATERIAL, Rarity.RARE, "res://interactive_items/icons/wood.png"),
	ItemID.GOLDEN_IDOL: InventoryItemBase.new(ItemID.GOLDEN_IDOL, "Golden Idol", false, 1, Category.RELIC, Rarity.RARE, "res://interactive_items/icons/wood.png"),
	ItemID.BONE_TOTEM: InventoryItemBase.new(ItemID.BONE_TOTEM, "Bone Totem", false, 1, Category.RELIC, Rarity.UNCOMMON, "res://interactive_items/icons/wood.png"),
	ItemID.VAMPIRE_FANG: InventoryItemBase.new(ItemID.VAMPIRE_FANG, "Vampire Fang", true, 15, Category.MATERIAL, Rarity.RARE, "res://interactive_items/icons/wood.png"),
	ItemID.SPECTRAL_KEY: InventoryItemBase.new(ItemID.SPECTRAL_KEY, "Spectral Key", false, 1, Category.KEY_ITEM, Rarity.RARE, "res://interactive_items/icons/wood.png"),
	ItemID.FIREFLY_JAR: InventoryItemBase.new(ItemID.FIREFLY_JAR, "Firefly Jar", true, 20, Category.CONSUMABLE, Rarity.COMMON, "res://interactive_items/icons/wood.png"),
	ItemID.NIGHTSHADE_GEM: InventoryItemBase.new(ItemID.NIGHTSHADE_GEM, "Nightshade Gem", true, 25, Category.MATERIAL, Rarity.RARE, "res://interactive_items/icons/wood.png"),
	ItemID.GRAVITY_PENDANT: InventoryItemBase.new(ItemID.GRAVITY_PENDANT, "Gravity Pendant", false, 1, Category.ACCESSORY, Rarity.RARE, "res://interactive_items/icons/wood.png"),
	ItemID.WARDENS_CREST: InventoryItemBase.new(ItemID.WARDENS_CREST, "Warden's Crest", false, 1, Category.ARMOR, Rarity.RARE, "res://interactive_items/icons/wood.png"),
	ItemID.SHAMAN_MASK: InventoryItemBase.new(ItemID.SHAMAN_MASK, "Shaman Mask", false, 1, Category.ARMOR, Rarity.UNCOMMON, "res://interactive_items/icons/wood.png"),
	ItemID.DUSK_MIRROR: InventoryItemBase.new(ItemID.DUSK_MIRROR, "Dusk Mirror", false, 1, Category.RELIC, Rarity.RARE, "res://interactive_items/icons/wood.png"),
	ItemID.WHISPER_SHELL: InventoryItemBase.new(ItemID.WHISPER_SHELL, "Whisper Shell", true, 10, Category.MATERIAL, Rarity.UNCOMMON, "res://interactive_items/icons/wood.png"),
	ItemID.AMBER_CRYSTAL: InventoryItemBase.new(ItemID.AMBER_CRYSTAL, "Amber Crystal", true, 99, Category.MATERIAL, Rarity.UNCOMMON, "res://interactive_items/icons/wood.png"),
	ItemID.ANCIENT_RELIC: InventoryItemBase.new(ItemID.ANCIENT_RELIC, "Ancient Relic", false, 1, Category.RELIC, Rarity.EPIC, "res://interactive_items/icons/wood.png"),
	ItemID.HOLY_SYMBOL: InventoryItemBase.new(ItemID.HOLY_SYMBOL, "Holy Symbol", false, 1, Category.ACCESSORY, Rarity.UNCOMMON, "res://interactive_items/icons/wood.png"),
	ItemID.WOLF_TOTEM: InventoryItemBase.new(ItemID.WOLF_TOTEM, "Wolf Totem", false, 1, Category.ACCESSORY, Rarity.UNCOMMON, "res://interactive_items/icons/wood.png"),
	ItemID.VOID_ESSENCE: InventoryItemBase.new(ItemID.VOID_ESSENCE, "Void Essence", true, 50, Category.MATERIAL, Rarity.RARE, "res://interactive_items/icons/wood.png"),
	ItemID.WITCHS_LOCKET: InventoryItemBase.new(ItemID.WITCHS_LOCKET, "Witch's Locket", false, 1, Category.ACCESSORY, Rarity.RARE, "res://interactive_items/icons/wood.png"),
	ItemID.CHIMERIC_FUR: InventoryItemBase.new(ItemID.CHIMERIC_FUR, "Chimeric Fur", true, 99, Category.MATERIAL, Rarity.UNCOMMON, "res://interactive_items/icons/wood.png"),
	ItemID.TEMPEST_GEM: InventoryItemBase.new(ItemID.TEMPEST_GEM, "Tempest Gem", true, 25, Category.MATERIAL, Rarity.RARE, "res://interactive_items/icons/wood.png"),
	ItemID.ASHEN_BAND: InventoryItemBase.new(ItemID.ASHEN_BAND, "Ashen Band", false, 1, Category.ACCESSORY, Rarity.RARE, "res://interactive_items/icons/wood.png"),
	ItemID.ICE_ROSE: InventoryItemBase.new(ItemID.ICE_ROSE, "Ice Rose", true, 15, Category.CONSUMABLE, Rarity.RARE, "res://interactive_items/icons/wood.png"),
	ItemID.STORM_FANG: InventoryItemBase.new(ItemID.STORM_FANG, "Storm Fang", false, 1, Category.WEAPON, Rarity.RARE, "res://interactive_items/icons/wood.png"),
	ItemID.RUNESTONE_EYE: InventoryItemBase.new(ItemID.RUNESTONE_EYE, "Runestone Eye", false, 1, Category.RELIC, Rarity.RARE, "res://interactive_items/icons/wood.png")
}

# Directly using the ITEM_SPEC_DATA instances; no extra build step needed

static func get_item_spec(id: int) -> InventoryItemBase:
	return ITEM_SPEC_DATA[id]

# Convenience helpers to access spec fields
static func name_for(id: int) -> String:
	return get_item_spec(id).name

static func is_stackable(id: int) -> bool:
	return get_item_spec(id).is_stackable

static func max_stack(id: int) -> int:
	return get_item_spec(id).max_stack

static func category_for(id: int) -> Category:
	return get_item_spec(id).category as Category

static func default_rarity_for(id: int) -> Rarity:
	return get_item_spec(id).default_rarity as Rarity

# Removed default_name_for: all item entries are expected to include a name.
