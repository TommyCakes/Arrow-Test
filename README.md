# ArrowSlide

A sliding-arrow puzzle game for iOS, inspired by AmazeGo. Slide rows and columns of coloured arrows to match a target arrangement — no ads, just puzzles.

## Gameplay

- Swipe **left/right** to slide all arrows in a row
- Swipe **up/down** to slide all arrows in a column  
- Arrows **wrap around** (toroidal grid) — they reappear on the other side
- **Ghost outlines** show where each arrow needs to end up
- Complete a level when every arrow matches its ghost

## Scoring

| Moves vs Par | Stars |
|---|---|
| ≤ par | ⭐⭐⭐ |
| ≤ par × 1.5 | ⭐⭐ |
| > par × 1.5 | ⭐ |

## Content

30 handcrafted puzzles in four packs:

| Pack | Levels | Grid |
|---|---|---|
| Tutorial | 1–5 | 4×4 |
| Easy | 6–15 | 5×5 |
| Medium | 16–25 | 6×6 |
| Hard | 26–30 | 6×6 |

Levels unlock sequentially. Best move counts are saved per level.

## Building

Requirements: **Xcode 15.4+**, iOS 17 deployment target.

1. Open `ArrowSlide/ArrowSlide.xcodeproj` in Xcode
2. Select your team under *Signing & Capabilities*
3. Choose an iOS 17 simulator or device and run

## App Store pricing

Planned retail price: **£2.99** (no ads, no IAP).

## Project structure

```
ArrowSlide/
├── ArrowSlide.xcodeproj/
└── ArrowSlide/
    ├── ArrowSlideApp.swift       # @main entry point
    ├── Models/
    │   ├── Arrow.swift           # Arrow, ArrowDirection, ArrowColor
    │   └── Level.swift           # Level definitions (all 30 puzzles)
    ├── Game/
    │   └── GameEngine.swift      # Slide logic, undo, reset, solve detection
    ├── Persistence/
    │   └── ProgressStore.swift   # UserDefaults-backed progress
    └── Views/
        ├── ArrowView.swift       # Single arrow tile
        ├── GridView.swift        # Drag-gesture grid
        ├── GameView.swift        # In-game screen + solved overlay
        └── LevelSelectView.swift # Pack/level picker
```
