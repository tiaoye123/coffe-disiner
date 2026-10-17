Essential UI SFX
================

150 sounds: 30 families x 5 genuine variations each.

WHY VARIATIONS
  Playing the same file fifty times gets noticed, and it gets tiring. Every
  family in this pack ships 5 genuinely different versions. They are
  not one file pitch-shifted: each is an independent synthesis with its own
  timbre, envelope and filtering. Pick one at random per playback and the
  sound never repeats itself.

  Unity:   clip = variants[Random.Range(0, variants.Length)];
  Godot:   $AudioStreamPlayer.stream = variants.pick_random()
  Unreal:  use a Sound Cue with a Random node

CONTENTS
  click          x5
  hover          x5
  keypress       x5
  select         x5
  confirm        x5
  cancel         x5
  error          x5
  alert          x5
  notify         x5
  toggle_on      x5
  toggle_off     x5
  open           x5
  close          x5
  transition     x5
  reward         x5
  unlock         x5
  scan           x5
  pop            x5
  swipe          x5
  tick           x5
  drop           x5
  dialogue       x5
  coin           x5
  purchase       x5
  equip          x5
  page           x5
  save           x5
  charge         x5
  levelup        x5
  deny           x5

FORMAT
  Mono WAV, 16-bit, 44100 Hz. Ready for Unity, Unreal, Godot and GameMaker.
  An OGG version is included in /ogg for lighter builds.

MANIFEST
  manifest.json lists every family and the exact path of each of its versions,
  so you can write a one-line import script instead of dragging files around.

INTEGRATION
  /integration has drop-in scripts for Unity and Godot that play the variations
  from a shuffled bag, so no clip ever repeats back-to-back. Plain random does
  repeat — about 8% of the time with 12 clips — and that repeat is the exact
  thing this pack exists to prevent. Read integration/README.txt first.


HOW IT WAS MADE
  Procedural synthesis from original code. No recordings, no third-party
  samples, no generative AI.

LICENSE
  Free for commercial use, royalty free, no attribution required. Reselling or
  redistributing the audio files as a pack is not permitted. Full terms in
  LICENSE.txt
