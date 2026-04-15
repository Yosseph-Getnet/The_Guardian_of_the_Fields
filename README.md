# The Guardian of the Fields

**Project Status:** Implementation Phase (v2.0) – Final Sprint
**Engine:** Godot 4.2.x (GDScript)

---

## 1. Project Overview

**"The Guardian of the Fields"** is an Ethiopian pixel-art action game where players defend the nation’s agricultural and livestock wealth across three distinct regions:

* The Highland Origins
* The Southern Savannah
* The Searing Salt Plains

The game combines cultural storytelling with fast-paced gameplay mechanics, emphasizing strategy, resource management, and survival.

---

## 2. System Requirements

* **Engine:** Godot 4.2.x (Standard Edition)
* **Programming Language:** GDScript
* **Version Control:** Git
* **OS:** Windows / Linux / macOS (Godot-supported)
* **RAM:** Minimum 4GB (8GB recommended)
* **Storage:** ~500MB free space

---

## 3. Repository Structure

```
/Assets    -> Sprites, animations, audio (res://Assets/)
/Scenes    -> Game scenes (.tscn) (res://Scenes/)
/Scripts   -> Game logic (.gd) (res://Scripts/)
/UI        -> HUD, menus, transitions (res://UI/)
/tasks     -> Task tracking and production logs
```

---

## 4. Setup & Installation (Getting Started)

### 1. Clone the Repository

```
git clone https://github.com/Yosseph-Getnet/The_Guardian_of_the_Fields.git
```

### 2. Open the Project

* Launch **Godot 4.x**
* Click **Import**
* Select the `project.godot` file in the root directory

### 3. Install Dependencies

* No external dependencies required
* Ensure correct Godot version (4.2.x)

### 4. Run the Game

* Open the main scene:

```
res://Scenes/Levels/L1_Main.tscn
```

* Click **Run** or press **F5**

---

## 5. Core Features

* Player-controlled Guardian character
* Multiple combat systems (Wenchif, Bow & Arrow)
* Region-based gameplay mechanics
* Enemy AI behaviors
* Health system and UI feedback
* Resource management mechanics (reload, stamina, thirst)

---

## 6. Current Feature Status

###  Implemented Features

| Feature           | Used on                                |
| ----------------- | ------------------------------------------ |
| Guardian Movement  | Level 1      |
| Wenchif Attack   | Level 1                |
| Baboon Attack     | Level 1    |
| Ammo Reload System   | Level 1                |
| Health System   | Level 1 |
| UI System      | Level 1      |
| Zebu Herd Movement      | Level 2      |
| Bow and Arrow Mechanics     | Level 2    |
| Rifle and Borkoto Mechanics     | Level 2   |
| Gile Dagger / Melee Input      | Level 3   |
| Heat and Thrist System       | Level 3    |
| Sandstorm Mechanics     | Level 3    |
| Caravan Escort     | Level 3   |
| Interactable water source   | Level 3  |
| Epilogue  | Level 3



---

###  In Progress Features

| Feature                 | Description                           |
| ----------------------- | ------------------------------------- |
| Thirst System (Level 3) | Survival mechanic for Salt Plains     |
| Camel Caravan Escort    | Escort gameplay system                |
| Global Variable Sync    | Proper state management across scenes |
| UI Improvements         | Transparency and clarity fixes        |


---

## 7. Integration Challenges & Known Issues

###  Major Integration Challenges

* Significant **merge conflicts across multiple branches** impacted development stability
* Lack of synchronization between systems led to **broken scene connections and logic inconsistencies**
* Integration bottlenecks affected Level 2 and Level 3 more heavily than Level 1

###  Known Issues

* Level 2 currently lacks a stable, playable build due to unresolved integrations
* Level 3 systems (thirst, caravan escort) are not fully connected
* Global variable synchronization issues across scenes
* UI transparency needs improvement in Level 2
* Minor balancing adjustments required for combat systems

---

* UI transparency needs improvement in Level 2
* Global variable synchronization issues in Level 3
* Minor balancing adjustments required for combat systems

---

## 8. Future Improvements

* Sound effects and background music integration
* Save/load system
* Difficulty scaling
* Mobile optimization
* Localization (Amharic + English)

---

## 9. Contribution Guidelines

1. Fork the repository
2. Create a new branch (for example `feature/your-feature`)
3. Commit your changes
4. Push to your branch
5. Open a Pull Request

---

## 10. License

This project is currently for academic and development purposes.

---

## 11. Contact

For questions or collaboration:

* GitHub: [https://github.com/Yosseph-Getnet](https://github.com/Yosseph-Getnet)

---

