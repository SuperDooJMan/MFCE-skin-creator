extends Resource
class_name PlayerSkin

const ANIMS: Array[String] = [
	"appear",
	"attack",
	"attack_air",
	"back",
	"climb",
	"crouch",
	"default",
	"fall",
	"grab",
	"hold_crouch",
	"hold_default",
	"hold_fall",
	"hold_jump",
	"hold_look_up",
	"hold_swim",
	"hold_walk",
	"idle",
	"jump",
	"kick",
	"look_up",
	"p_run",
	"p_fall",
	"p_jump",
	"skid",
	"slide",
	"swim",
	"swim_idle",
	"swim_down",
	"swim_up",
	"walk",
	"warp",
	"win",
]

const STATES: Array[String] = [
	"small",
	"super",
	"iceball",
	"green_lui",
	"fireball",
	"boomerang",
	"beetroot",
	"frog",
]

const RECT_ZERO: Rect2 = Rect2(0,0,0,0)

@export var name: StringName = &"small" # State name
@export var animation_speeds: Dictionary = {
	"appear": 30,
	"attack": 10,
	"attack_air": 15,
	"back": 0,
	"climb": 0,
	"crouch": 0,
	"default": 0,
	"fall": 0,
	"grab": 5,
	"hold_crouch": 0,
	"hold_default": 0,
	"hold_fall": 0,
	"hold_jump": 0,
	"hold_walk": 6,
	"jump": 0,
	"kick": 4,
	"skid": 0,
	"slide": 0,
	"swim": 8,
	"walk": 6,
	"warp": 0,
	"win": 0,
}
@export var animation_regions: Dictionary = {
	"appear": [
		Rect2(0, 0, 32, 64),
		Rect2(32, 0, 32, 64),
		Rect2(64, 0, 32, 64),
	],
	"attack": [
		Rect2(0, 0, 32, 64),
	],
	"attack_air": [
		Rect2(0, 0, 32, 64),
		Rect2(32, 0, 32, 64),
		Rect2(64, 0, 32, 64),
	],
	"back": [
		Rect2(0, 0, 32, 64),
	],
	"climb": [
		Rect2(0, 0, 32, 64),
	],
	"crouch": [
		Rect2(0, 0, 32, 64),
	],
	"default": [
		Rect2(0, 0, 32, 64),
	],
	"fall": [
		Rect2(0, 0, 32, 64),
	],
	"grab": [
		Rect2(0, 0, 32, 64),
		Rect2(32, 0, 32, 64),
	],
	"hold_crouch": [
		Rect2(0, 0, 32, 64),
	],
	"hold_default": [
		Rect2(0, 0, 32, 64),
	],
	"hold_fall": [
		Rect2(0, 0, 32, 64),
	],
	"hold_jump": [
		Rect2(0, 0, 32, 64),
	],
	"hold_walk": [
		Rect2(0, 0, 32, 64),
		Rect2(32, 0, 32, 64),
		Rect2(64, 0, 32, 64),
	],
	"jump": [
		Rect2(0, 0, 32, 64),
	],
	"kick": [
		Rect2(0, 0, 32, 64),
	],
	"skid": [
		Rect2(0, 0, 32, 64),
	],
	"slide": [
		Rect2(0, 0, 32, 64),
	],
	"swim": [
		Rect2(0, 0, 32, 64),
		Rect2(32, 0, 32, 64),
		Rect2(64, 0, 32, 64),
		Rect2(0, 0, 32, 64),
		Rect2(32, 0, 32, 64),
		Rect2(64, 0, 32, 64),
		Rect2(96, 0, 32, 64),
		Rect2(128, 0, 32, 64),
	],
	"walk": [
		Rect2(0, 0, 32, 64),
		Rect2(32, 0, 32, 64),
		Rect2(64, 0, 32, 64),
	],
	"warp": [
		Rect2(0, 0, 32, 64),
	],
	"win": [
		Rect2(0, 0, 32, 64),
	],
}
@export var animation_loops: Dictionary = {
	"appear": true,
	"attack": false,
	"attack_air": false,
	"back": false,
	"climb": false,
	"crouch": false,
	
	"default": false,
	"fall": false,
	"grab": false,
	"hold_crouch": false,
	"hold_default": false,
	
	"hold_fall": false,
	"hold_jump": false,
	"hold_walk": true,
	"jump": false,
	"kick": false,
	
	"skid": false,
	"slide": false,
	"swim": true,
	"walk": true,
	"warp": true,
	"win": true,
}
@export var animation_durations: Dictionary = {}

var baked_frames: SpriteFrames
var res_path: String

func gen_animated_sprites(force_regen: bool = false) -> SpriteFrames:
	if baked_frames:
		if !force_regen:
			return baked_frames
	
	var frames := SpriteFrames.new()
	
	for anim in ANIMS:
		if !animation_regions.keys().has(anim):
			continue
		if !frames.has_animation(anim):
			frames.add_animation(anim)
		
		frames.set_animation_loop(anim, animation_loops[anim])
		frames.set_animation_speed(anim, animation_speeds[anim])
		if !anim in animation_durations.keys():
			animation_durations[anim] = []
		if len(animation_durations[anim]) < len(animation_regions[anim]):
			animation_durations[anim].resize(len(animation_regions[anim]))
			animation_durations[anim].fill(1.0)
		
		var img_file := res_path + "/" + anim + ".png"
		var image: Image
		if !FileAccess.file_exists(img_file):
			print("No image for: ", anim)
			if anim != "appear":
				frames.remove_animation(anim)
				continue
			else:
				var state := res_path.get_slice("/", res_path.get_slice_count("/") - 1)
				var base_img: Texture2D = AnimGenerator.TEXTURES.small
				if AnimGenerator.TEXTURES.has(state):
					base_img = AnimGenerator.TEXTURES[state]
				image = AnimGenerator.gen_animation_image(
					anim,
					AnimGenerator.get_offset_dict(state),
					base_img.get_image()
				)
		
		if !image: image = Image.load_from_file(img_file)
		var img_texture := ImageTexture.create_from_image(image)
		
		for i in len(animation_regions[anim]):
			var anim_region = animation_regions[anim][i]
			
			if anim_region == RECT_ZERO:
				print("Rect is zero for: ", anim)
			
			var atlas := AtlasTexture.new()
			atlas.atlas = img_texture
			atlas.region = anim_region
			
			frames.add_frame(anim, atlas, animation_durations[anim][i])
	
	baked_frames = frames
	return frames
