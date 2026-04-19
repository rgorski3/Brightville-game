# Brightville Helpers

A fun children's game built in Godot 4.x. Players explore the town of Brightville
and help out in three mini-games that teach route planning, budgeting, and
matching.

See [`brightville_spec.md`](./brightville_spec.md) for the full design spec.

## Project layout

```
Scenes/        # MainMenu + three subgame scenes
Scripts/
  Global/      # Autoload singletons (GameState, SceneTransition)
  Subgames/    # Per-subgame logic
  MainMenu.gd
  BaseGame.gd  # Parent class for all subgames
Assets/        # Audio + sprite placeholders
Prefabs/UI/    # Reusable UI prefabs
```

## Running

Open `project.godot` in Godot 4.2+ and press Play. The main scene is
`Scenes/MainMenu.tscn`.
