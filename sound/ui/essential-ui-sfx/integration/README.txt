INTEGRATION
===========

Two drop-in scripts so you can use the variations properly in five minutes.

  Unity_RandomSfx.cs      Unity 2021+   — add to a GameObject with an
                                       AudioSource, fill `variations`, call
                                       Play() from your button
  Godot_random_sfx.gd     Godot 4      — add as a child node, fill
                                       `variations`, connect the button's
                                       `pressed` signal to `play_random`

WHY NOT JUST Random.Range / pick_random()
  Because plain random repeats. With 12 clips, picking at random plays the same
  one twice in a row roughly 8% of the time — and a back-to-back repeat is the
  exact moment a player notices the sound is canned. That is what this pack
  exists to prevent, so picking badly throws away what you bought.

  Both scripts use a shuffled bag instead: every clip plays once before any
  clip plays again, and a reshuffle can never put the same clip back-to-back.

UNREAL
  Use a Sound Cue with a Random node and tick "Randomize Without Replacement".
  Same idea, already built in.

PITCH
  Both scripts expose a small pitch jitter, default 3%. Leave it low. These
  clips already differ from each other in timbre and envelope, and stacking a
  wide pitch shift on top makes them sound processed rather than varied.
