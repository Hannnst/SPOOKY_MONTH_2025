# Scene & Interaction Documentation

## ✅ Change Scene with `SceneManager`

The **global** `SceneManager.tscn` handles scene transitions and plays a fade-to-black animation.

### Steps

**1️⃣** Make sure the scene name and path exist in the SceneManager dictionary:

```gdscript
# SceneManager.gd
{
	scene_name : scene_path
}
```

**2️⃣** Call the change function:

```gdscript
SceneManager.change_scene("scene_name")
```

---

## ✅ Add Interactions to Objects / Items

If you want the player to interact with something in the game…

### Steps

**1️⃣** Click the *chainlink icon* and select:  
`InteractionArea.tscn`

**2️⃣** Add a `CollisionShape2D` as a child of `InteractionArea`.

Your hierarchy should look like:

```
Object
└── InteractionArea
	└── CollisionShape2D
```

Add a shape to the `CollisionShape2D` and scale it to fit your object.

**3️⃣** Add this to your object’s script:

```gdscript
# Dette må legges til på alle interactable objekter:
@onready var interaction_area = $InteractionArea

func _ready():
	# Denne linjen må legges til i ready funksjonen.
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	# Unik kode for hva som skjer i spillet når brukeren interacter med objectet.
	sprite.flip_v = !sprite.flip_v
```

---

## 🧠 Interaction System Overview

- **InteractionManager (Global)**  
  Tracks objects inside the player's **InteractionSensor** and sorts by distance.  
  → Player interacts with the **closest** interactable object.

- **InteractionArea**
  - Detects when the player enters range
  - Notifies `InteractionManager`
  - Contains an overridable `interact()` callable

- **Player**
  - Has an **InteractionSensor** (`Area2D`)
  - Only objects the player is *facing* can be interacted with

---

## 💬 Displaying Dialogue on Screen

We use: **DialogueManager 3 Plugin**  
📄 Full documentation: https://github.com/nathanhoad/godot_dialogue_manager/tree/main?tab=readme-ov-file#readme

### Steps

**1️⃣** Create new dialogue content  
Go to the **Dialogue tab** → *Start a new file*  
➡️ Save it inside: `res://dialogues/`

**2️⃣** Trigger a dialogue in code  
(Usually inside an `interact()` function)

```gdscript
var dialogue = load("res://dialogues/funny_test.dialogue") # Replace with your file
DialogueManager.show_dialogue_balloon(dialogue, "start")    # Replace with your dialogue key
```

This spawns a new dialogue balloon and displays the text.

---

### Example

In this `example.dialogue` file:

- `"start"`  
- `"second_dialogue"`

Each one triggers a separate set of dialogue lines.
