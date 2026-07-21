# Handoff — PR #1 (feat/improved-world) review follow-ups

Written 2026-07-19 after a code review of [https://github.com/DeClaessens/incremental/pull/1](https://github.com/DeClaessens/incremental/pull/1).
Work through the blockers first; the rest can land in this PR or a follow-up.
Delete this file once everything is done.

---

## Blockers (fix before merging)

### 1. Delete the committed editor temp file (duplicate UID!)

`scenes/islands/Island.tscn10215274989.tmp` is an editor crash-leftover and it
contains the **same UID as** `Island.tscn` (`uid://di2ousspwgyt0`). Godot scans
every file for UIDs, so this makes resource resolution ambiguous.

- [x] `git rm scenes/islands/Island.tscn10215274989.tmp`
- [x] Add `*.tmp` to `.gitignore`

### 2. Fix stale overrides in `BigIsland.tscn`

`scenes/islands/BigIsland.tscn` lines 11–12 override properties from an older
version of SpawnComponent that no longer exist:

```
MAX_NODE_COUNT = 1
gatherables = NodePath("../Gatherables")
```

There is no `Gatherables` node anymore, so Godot logs errors when this scene
loads — and it's the island `main.tscn` actually uses. Side effect: BigIsland
falls back to the base scene's `capacity = 1`, which is probably too low for
the big island.

- [x] Open BigIsland.tscn in the editor and re-save (or hand-delete the two lines)
- [x] While you're there: decide on a real `capacity` for BigIsland

### 3. Wrong return type in `gatherable_field_component.gd`

`components/gatherable_field/gatherable_field_component.gd:11`

```gdscript
func has_capacity() -> int:    # returns a bool comparison
```

GDScript 4 doesn't implicitly convert bool → int, so this raises a script error.

- [x] Change `-> int` to `-> bool`

---

## Known issue you already flagged: gatherables spawn in the ocean

`get_random_spawn_position()` picks from **all** used cells, including
cliff/water edge tiles. Recommended fix that keeps the component generic:

1. In `tilesets/ground_tile_set.tres`, add a custom data layer `spawnable`
   (type: bool) and set it to `true` on the walkable grass tiles only.
2. Filter in `gatherable_field_component.gd`:

```gdscript
func get_random_spawn_position() -> Vector2:
	var cells := tile_map_layer.get_used_cells().filter(
		func(c): return tile_map_layer.get_cell_tile_data(c).get_custom_data("spawnable")
	)
	if cells.is_empty():
		push_warning("No spawnable cells on %s" % tile_map_layer.get_path())
		return Vector2.ZERO
	return tile_map_layer.map_to_local(cells.pick_random())
```

The empty-array guard matters regardless: `pick_random()` on an empty array is
a runtime error (hits anyone who instances the component before painting tiles).

- [x] Add `spawnable` custom data layer to the tileset
- [x] Filter + empty guard in `get_random_spawn_position()`

---

## Composition-over-inheritance improvements (your stated goal)

The component split (GatherableFieldComponent = placement/capacity,
SpawnComponent = timing/instantiation) is working. Two places to push further:

### SpawnComponent hardcodes what it spawns

`components/spawn/spawn_component.gd` preloads `Gatherable.tscn` + `tree.tres`,
making it a "TreeSpawnComponent" in practice. Export the loot instead:

```gdscript
@export var gatherable_resources: Array[GatherableResource]
```

then `gatherable_resources.pick_random()` on timeout. Each island variant then
composes its own loot table in the inspector — that's the composition payoff.

- [x] Export the resource list, remove the hardcoded tree preload
- [x] Set per-island loot in Small/Big/SplitIsland scenes

### Player polls the input component every frame

`scenes/player/player.gd` reads `input_component.is_moving` in `_process` and
holds a concrete `MovementInputComponent` reference. More compositional:

- Have `movement_input_component.gd` emit `movement_started` /
  `movement_stopped` **only on transitions** (track previous state).
- Connect the player (or a small AnimationComponent) to those signals.

This also removes the `_physics_process`-write / `_process`-read frame skew,
and lets you swap in an AI input component later without touching the player.

- [ ] Replace the polling in `player.gd` with signal connections

### Watch out for scene-inheritance rot

The island variants use scene inheritance (fine for data-only overrides like
tile data), but blocker #2 above is exactly its classic failure mode: base
changes rot silently in children. If variants ever need different _behavior_,
consider one Island scene + an exported `IslandResource` (tile data, capacity,
loot) instead.

---

## Small cleanups (nice-to-have)

- [x] `Player.tscn` root node has `skew = 0.0023799923` — accidental editor
  ```
  drag; reset to 0.
  ```
- [x] `SmallIsland` / `SplitIsland` inherit an **empty** `CollisionPolygon2D`
  ```
  (only BigIsland overrides the polygon). If the Area2D is the island
  unlock sensor, those two have zero area. Give each island a polygon, or
  warn from `island.gd` when it's empty.
  ```
- [x] `spawn_component.gd`: constants → `SCREAMING_SNAKE_CASE`
  ```
  (`GATHERABLE_SCENE`, `TREE_RESOURCE`).
  ```
- [x] `movement_input_component.gd`: move `var is_moving` below the `@export`s
  ```
  (convention: signals, enums, consts, exports, vars).
  ```
- [x] `player.gd`: `_process(delta)` doesn't use `delta` — rename to `_delta`.
  ```
  The second `if` block also simplifies to a plain `else: animation_player.stop()`.
  ```
- [x] Known quirk, no action needed: `has_capacity()` counts children while
  ```
  depleted gatherables `queue_free()` (deferred) — counts can be off by one
  within a single frame.
  ```

## Longer term

- No tests in the project yet. Plain-Node components like these are exactly the
  testable kind — GUT or GdUnit4 would be worth adding once components stabilize.
