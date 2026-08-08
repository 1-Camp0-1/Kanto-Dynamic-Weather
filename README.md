# Kanto Dynamic Weather

A dynamic 3D weather and atmosphere add-on for **Pokémon Gen1Recomp** and **Dramatic Shape**.

Kanto Dynamic Weather turns Dramatic Shape's voxel overworld into a living weather system: world-space cloud fields, rolling fog, volumetric-looking sunlight, rain and thunderstorms, persistent puddles, atmospheric particles, upgraded celestial rendering, and a distant horizon that makes the map feel like part of a larger world.

**Author:** Campo (`1-Camp0-1`)

## Requirements

- Pokémon Gen1Recomp compatible with mod API 2 (`>=0.1.37 <2.0.0`; the development version is also accepted by the manifest)
- **Dramatic Shape 1.7.2 or newer 1.7.x**
- VOXEL rendering enabled in Dramatic Shape

The installable ZIP does **not** contain Dramatic Shape. The mod declares `DRAMATIC_SHAPE@>=1.7.2 <1.8.0` as a hard dependency, so Gen1Recomp loads Dramatic Shape first and blocks this add-on cleanly when the dependency is absent or outside the supported range.

## Installation

1. Install and enable Dramatic Shape 1.7.2 or a compatible newer 1.7.x release.
2. Download `kanto_dynamic_weather-1.0.3.zip` from Releases.
3. Install the ZIP through Gen1Recomp's mod manager.
4. Enable **Kanto Dynamic Weather**.
5. Use a Dramatic Shape **VOXEL** camera mode.

Do not replace the Dramatic Shape ZIP with this add-on. They are separate mods and should both remain installed.

## Weather presets

The OPTIONS menu adds:

- **DYNAMIC** — automatic branching weather simulation
- **CLEAR**
- **PARTLY CLOUDY** — the calibrated ~25% cloud-cover reference
- **MOSTLY CLOUDY** — ~75% apparent coverage
- **CLOUDY** — ~90–95% broken cover
- **OVERCAST** — closed 100% cloud ceiling
- **RAINING**
- **THUNDERSTORM**

Dynamic weather does not simply march up and down one severity ladder. Cloud cover evolves through Clear / Partly / Mostly / Cloudy / Overcast, while rain can branch from Cloudy or Overcast, intensify into a Thunderstorm, or clear back toward Cloudy/Overcast.

### Weather speed

- **SLOW** — long-lived weather systems
- **NORMAL** — intended gameplay pacing
- **FAST** — approximately half-length systems
- **VERY FAST** — testing mode; each recognisable state holds for about two minutes before a short transition

## Atmosphere controls

- **ATMOSPHERE:** FULL / LOW / OFF
- **LIGHT INTENSITY:** 1–10 (default 5)
- **PARTICLE DENSITY:** 1–10 (default 6)
- **PARTICLE SCALE:** 1–10 (default 8)

Rain calibration is authored by preset rather than exposed as extra sliders:

- Raining: size 3 / density 4
- Thunderstorm: size 3 / density 6, with faster fall and stronger wind

Ambient spores/motes are suppressed completely while Raining or Thunderstorm is active.

## Features

### 3D clouds and lighting

Cloud formations occupy real world-space depth rather than a screen overlay. Near, middle and distant formations provide parallax, move with a persistent wind field, and attenuate Dramatic Shape's volumetric light shafts. Dense cloud cores can heavily suppress direct beams while gaps allow sunlight through.

### Fog

Ground fog is depth-tested world geometry with moving density, rolling crests and aspect-ratio compensation so portrait and landscape do not represent different weather intensities.

### Rain and thunderstorms

Rain drops are real 3D streaks distributed through the voxel scene. Buildings, trees and terrain can occlude them naturally. Thunderstorms increase density, speed and wind and add irregular atmospheric lightning flashes that illuminate sky, clouds, fog, rain and terrain together.

### Persistent puddles

Rain forms stylised world-space puddles. They remain at full size immediately after rain and shrink on subsequent dry weather transitions until they evaporate. New rain refills them. Character reflections conceptually exist beneath the map and puddles act as masks that reveal the reflected sprite, avoiding touch-triggered reflection popping.

### Sun, moon and distant world

The original pixel celestial discs are replaced by smoother atmospheric bodies tied to the same day/night lighting direction. A low-detail continuation world, forest belts, foothills and mountain ridges extend beyond the loaded map so the sun and moon can visually set behind distant terrain instead of an empty blue void.

## Dramatic Shape compatibility

This project deliberately keeps all Dramatic Shape-specific integration in `compat/`.

Dramatic Shape 1.7.2 exports `mod.exports.lib`, which this add-on uses as its public dependency entry point. The current Dramatic Shape renderer does not expose a dedicated atmosphere-stage callback, however, so three renderer modules require small **in-memory compatibility patches** while the game starts:

- `Sky.lua`
- `Voxel3D.lua`
- `VoxelScene.lua`

Dramatic Shape is never modified on disk and its full source is not bundled in this mod.

The manifest accepts Dramatic Shape `>=1.7.2 <1.8.0`. The bridge applies its changes by verified source anchors rather than version number alone. If a later 1.7.x release changes one of those integration points, Kanto Dynamic Weather fails closed with an explicit compatibility message instead of silently corrupting the renderer. Usually only the compatibility bridge then needs updating; the weather simulation itself remains independent.

A future official Dramatic Shape atmosphere/render hook can replace this bridge without redesigning the weather system.

## Performance

The system was designed around Android constraints:

- fog, clouds, motes and rain use ordinary depth-tested geometry rather than requiring a readable scene-depth texture;
- cloud/light interaction reuses Dramatic Shape's existing shadow information;
- distant scenery is deliberately low-detail;
- **ATMOSPHERE LOW** reduces atmospheric volume cost while retaining the complete weather model.

Performance still depends on device, viewport resolution, Dramatic Shape anti-aliasing and camera settings.

## Known limitations

- The compatibility bridge is tied to Dramatic Shape's 1.7.x renderer structure. A source-breaking Dramatic Shape update may require a small compatibility release.
- Weather is a presentation system; it does not currently change Pokémon encounters, moves, damage or gameplay mechanics.
- The stylised puddle reflection system intentionally favours a Pokémon-like readable reflection over physically complete scene reflection.

## Development / release structure

The repository contains only this add-on's code and compatibility bridge. For a GitHub Release, package the mod files so `manifest.json` and `main.lua` are at the root of the installable ZIP (not inside an extra enclosing folder).

The release asset for this version is:

```text
kanto_dynamic_weather-1.0.3.zip
```

## Credits

- **Campo (`1-Camp0-1`)** — Kanto Dynamic Weather design and project owner
- **DramaticShape** — Dramatic Shape Voxel Mod, required dependency
- **Gen1Recomp contributors** — mod API and game runtime

Pokémon is a trademark of Nintendo / Creatures Inc. / GAME FREAK. This is an unofficial fan-made modification.

