# Project Spec: Brightville Helpers

**Engine:** Godot 4.x (C# or GDScript)
**Art Style:** 2D Vector, PBS Kids-inspired
**Resolution:** 1920x1080 (Landscape)

---

## 1. Project Architecture

```
res://
├── Scenes/
│   ├── MainMenu.tscn          # The City Map Hub
│   ├── Subgame_Transit.tscn    # Subgame 1
│   ├── Subgame_Shopping.tscn   # Subgame 2
│   └── Subgame_Hotel.tscn      # Subgame 3
├── Scripts/
│   ├── Global/
│   │   └── GameState.gd       # Singleton for scores/badges
│   └── BaseGame.gd            # Parent class for subgame logic
├── Assets/
│   ├── Audio/ (VO and SFX)
│   └── Sprites/ (City, UI, Characters)
└── Prefabs/
    └── UI/ (Inventory, Dialogue Bubbles)
```

---

## 2. Subgame Specifications

### Subgame 1: The Brightville Express (Transit Tracker)

- **Objective:** Select the fastest route to a destination.
- **Logic:**
  - Compare two variables: `bus_time` and `train_time`.
  - Success condition: `selected_route.time == min(bus_time, train_time)`.
- **Visuals:**
  - Simplified "Brightville" map with stylized L-train tracks and bus lines.
  - Destinations: Dino-Museum, Cloud Marble Park, Sparkle Pier.

### Subgame 2: Brightville Bazaar (Shopping)

- **Objective:** Identify which of two items can be purchased with a set budget.
- **Logic:**
  - `player_money` is a random int between 5 and 20.
  - `item_a.price` and `item_b.price` are generated.
  - One item must be `> player_money`, one must be `<= player_money`.
- **UI:** Drag-and-drop interface from "Shelf" to "Shopping Bag."

### Subgame 3: Grand Brightville Hotel (Front Desk)

- **Objective:** Match 3 guest requests to inventory items.
- **Locations:**
  - Main Street Inn (Tutorial/Basic)
  - Riverbank Resort (Nature/Water items)
  - Sky-High Plaza (Fancy/Modern items)
- **Logic:**
  - Guest emits a `RequestSignal` containing an array of 3 `ItemID`s.
  - Player must click matching `ItemButton`s in the desk inventory.

---

## 3. Global Technical Requirements

### Interaction Model

- **Input:** Primary mouse click / Touch input only.
- **Accessibility:** All text instructions must have a corresponding `AudioStreamPlayer` trigger for Voiceover (VO).

### "Juice" & Polish (The PBS Kids Feel)

- **Feedback Loops:**
  - Positive: High-pitch chime, character "happy" animation, star particles.
  - Negative: Soft "uh-oh" buzzer, character "thinking" pose, item shakes.
- **Transitions:** Every scene change should use a `CanvasLayer` fade-to-color transition to prevent jarring jumps.

---

## 4. Claude Code Implementation Prompts

Use these prompts once you initialize the project:

- **Prompt 1:** "Based on brightville_spec.md, create a Global `GameState.gd` singleton to track badges earned in the three subgames."
- **Prompt 2:** "Create the scene structure for `Subgame_Shopping.tscn` with a wallet display and two item slots using `ColorRect`s as placeholders."
- **Prompt 3:** "Write a GDScript for the Transit Tracker that compares two travel times and moves a `Sprite2D` along a `Path2D` when the correct one is clicked."
