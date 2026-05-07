Student Name: Maksym Zinkovskyi
Student number: A00020544

## Links

Itch: https://mzinr.itch.io/daymare
Video: https://youtu.be/jdzqVLmaSxA

## Info

Game opens on a 2D "counting sheep" screen that also acts as the main menu. Press Play and player drops into an apartment, an alarm is screaming, and there is a short list of morning chores to get through before we can leave. Walking out of the front door (or hitting restart) sends you back to the sheep, so the whole thing loops between dreaming and waking.

## Controls

**Sheep minigame (menu)**

- `Space` makes the current sheep jump
- The Play button (top-left) starts the apartment

**Apartment**

- `WASD` to move
- Mouse to look
- `E` to interact or pick up
- `Q` to drop what you are holding
- `R` to restart (sends you back to the sheep)
- `Esc` to release the cursor

## Gameplay sequence

The game loops between the 2D minigame and the 3D apartment.

1. **Sheep minigame / menu.** Sheep walk in from the left toward a fence in the middle. Time your space-press right and the sheep jumps over, the counter ticks up, and the next one spawns. Time it badly and the sheep hits the fence and falls off the bottom of the screen. The Play button starts the apartment.
2. **Wake-up.** You start in the bedroom, the alarm clock is ringing. First objective is to shut it off.
3. **Get to the kitchen.** Self-explanatory. There is an area trigger on the kitchen floor.
4. **Find the pan.** Somewhere in the apartment.
5. **Put the pan on the stove.** A glowing ghost shows you where it goes.
6. **Find an egg.** It is in the kitchen too.
7. **Drop the egg into the pan.** The egg slot only becomes active once the pan is sitting on the stove, so the player physically can't do this step out of order.
8. **Cook the egg.** Press E on the stove. The egg and the pan fade out together.
9. **Leave.** Walk out the front door. The screen fades to black and you are back at the sheep.

A quest panel in the top-right lists the steps so player always know what is next, with `[✓]` next to the ones that are done and `[ ]` next to the active one.

## Features and functions

**Apartment**

- First-person character controller (mouse-look, walking)
- Raycast-based interaction from the camera
- Outline shader that lights up anything you can interact with
- Carry in front pickup system, with a separate drop key
- Placement slots that match by item type (`frying_pan`, `egg`)
- Nested placement: the pan has its own slot for the egg, but only after the pan is placed on the stove
- Pulsing ghost previews to show where each item belongs
- Quest manager with a hardcoded chain and a small queue for out of order steps
- Quest UI panel that rebuilds whenever progress changes
- Footstep audio that plays on a timer while moving
- Pickup and door sounds routed through a central SoundManager
- Looping ambient music
- Looping alarm clock that cuts the moment the first quest finishes
- Doors that swing away from the player based on their relative position
- Exit area that fades to black and returns to the menu
- Restart key that goes back to the menu instead of reloading the apartment

**Sheep minigame**

- 2D Node2D scene with a hand-drawn background, fence, sheep sprite, and counter
- Tween-based jump arc, with a small forward speed boost while in the air
- Side to side sinus wave wobble on the sheep so it looks like it is actually walking
- Single sheep on screen at a time, with randomised spawn gaps
- Fence collision: ground-level overlap triggers a parallel y-drop and rotation tween, then `queue_free`
- Counter only ticks up on a clean clear, never on a fail
- Per-event audio: ambient loop, jump, success bleat, fail bleat
- Cursor restored on entry so the menu still works after the apartment captured it
- Fade-in on load and fade-out on Play, with the ambient track ducking during the transition

## Visuals

The apartment runs on a soft pink and orange light scheme with volumetric fog and a custom gradient sky shader. The aim was for a familiar room to feel like something you are remembering rather than something you are inside, and the colour palette is doing most of that work. That is where "Daymare" comes from, the place is recognisable but the light is wrong.

The sheep minigame is hand-drawn and deliberately scrappy. A wobbly sheep, a brown plank fence, and a starry sky with uneven stars. 


The UI is a dark panel with white text.

## Assets

**3D**

- KayKit Furniture Bits (KayKit, itch.io)
- KayKit Restaurant Bits (KayKit, itch.io) for the stove and frying pan
- KayKit Prototype Bits (KayKit, itch.io) for the door
- styloo Food and Kitchen Asset Pack for the egg

**2D**

- Sheep, fence, and starry sky background was drawn by me

**Sound**

- Sheep success and fail sounds recorded by me
- Ambient music: "to_north - piano - calm - dreaming"
- Alarm clock: ultra-edward (freesound.org)
- Jump, footstep, door, pickup, and minigame ambient track sourced from freesound.org and royalty-free libraries

## Reflection

The part I am most pleased with is the pan and egg placement. I wanted the egg slot to live inside the pan so the player could see where it goes from the start, but I also did not want the egg to be droppable into the pan until the pan was actually on the stove. The version that works disables the child slot while the parent is being held and reenables it on placement. It took me a few rewrites to make it that clean.

Working on this also gave me a much better feel for Godot's signals, groups, and nodes. But I spent much more time on this than I expected (30 to 40 hours)

The thing I ended up with is short but actually finished, which I think is the best thing about it and now I am happy.
