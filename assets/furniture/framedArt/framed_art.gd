extends Node2D

# === Default placeholder textures (replace these paths with your own) ===
const DEFAULT_FRAME: Texture2D = preload("res://assets/furniture/framedArt/picture_frame.webp")
const DEFAULT_PICTURE: Texture2D = preload("res://assets/furniture/framedArt/looking.webp")

# === Exported variables ===
@export var frame_texture: Texture2D = DEFAULT_FRAME:
	set(value):
		frame_texture = value if value else DEFAULT_FRAME
		_update_textures()

@export var picture_texture: Texture2D = DEFAULT_PICTURE:
	set(value):
		picture_texture = value if value else DEFAULT_PICTURE
		_update_textures()

# Overall size of the entire framed picture
@export var size: Vector2 = Vector2(256, 256):
	set(value):
		size = value
		_update_layout()

# Inner picture margin (padding between frame and picture)
@export var inner_margin: float = 10.0:
	set(value):
		inner_margin = value
		_update_layout()


func _ready():
	_update_textures()
	_update_layout()


func _update_textures():
	if $FrameSprite:
		$FrameSprite.texture = frame_texture
	if $PictureSprite:
		$PictureSprite.texture = picture_texture


func _update_layout():
	if not $FrameSprite.texture or not $PictureSprite.texture:
		return

	# --- Scale frame to match desired overall size ---
	var frame_tex_size = $FrameSprite.texture.get_size()
	if frame_tex_size.x != 0 and frame_tex_size.y != 0:
		$FrameSprite.scale = size / frame_tex_size

	# --- Scale inner picture to fit inside frame with margin ---
	var picture_tex_size = $PictureSprite.texture.get_size()
	if picture_tex_size.x != 0 and picture_tex_size.y != 0:
		var inner_size = size - Vector2(inner_margin * 2, inner_margin * 2)
		var scale_factor = min(inner_size.x / picture_tex_size.x, inner_size.y / picture_tex_size.y)
		$PictureSprite.scale = Vector2(scale_factor, scale_factor)

	# --- Center the picture inside the frame ---
	$PictureSprite.position = Vector2.ZERO
