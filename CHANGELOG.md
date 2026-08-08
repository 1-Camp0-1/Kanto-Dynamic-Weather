# Changelog

## 1.0.3
- Fixed Dramatic Shape 1.7.2 Voxel3D compatibility check failing at hunk 10.
- Fog/cloud-shadow integration now uses a minimal stable anchor instead of depending on 1.7.0 viewport comments.
- Compatibility bridge now accepts already-applied hunks and includes a semantic Voxel3D fog fallback for compatible 1.7.x builds.
- No weather visuals or tuning changed from 1.0.2.
- Added public GitHub repository metadata for `1-Camp0-1/Kanto-Dynamic-Weather` and cleaned release documentation.

## 1.0.2 - Pre-repository import hotfix

- Removed the optional manifest `github` field from the installable build until the public repository exists.
- Retains Dramatic Shape 1.7.2+ / 1.7.x dependency and compatibility bridge from 1.0.1.

All notable changes to Kanto Dynamic Weather are documented here.

## 1.0.1 — 2026-08-08

### Dramatic Shape 1.7.2 compatibility
- Raised the tested dependency baseline to Dramatic Shape 1.7.2.
- Updated the VoxelScene compatibility anchor for Dramatic Shape 1.7.2's `ViewBox.stop()` cleanup path.
- Preserves the 1.7.2 render-distance / viewport cleanup while clearing Kanto Dynamic Weather's temporary renderer state.
- Retains fail-closed compatibility checking for later 1.7.x releases.

## 1.0.0 — 2026-08-08

### Production split
- Separated the weather system from the modified Dramatic Shape development build.
- New permanent mod ID: `kanto_dynamic_weather`.
- Declared Dramatic Shape `>=1.7.0 <1.8.0` as a required dependency.
- Added a fail-closed 1.7.x compatibility bridge using Dramatic Shape's exported library namespace.
- Dramatic Shape is no longer bundled or modified on disk.

### Weather
- Branching Dynamic weather simulation.
- Clear, Partly Cloudy, Mostly Cloudy, Cloudy, Overcast, Raining and Thunderstorm presets.
- Slow, Normal, Fast and Very Fast transition speeds.
- Smooth cloud, sky, fog, light and precipitation interpolation.
- Rain and Thunderstorm suppress ambient atmospheric spores.

### Atmosphere
- Android-safe world-space rolling fog.
- Depth-tested atmospheric motes with Density and Scale controls.
- Broad volumetric-looking sunlight with Light Intensity 1–10.
- World-space volumetric-style clouds with parallax and weather-dependent coverage.
- Clouds attenuate sunlight shafts and cast moving atmospheric shadowing.

### Rain / storms
- 3D rain particles with authored Raining and Thunderstorm calibrations.
- Fixed monotonic rain animation during weather-speed transitions.
- Irregular atmospheric lightning bursts for thunderstorms.

### Wet weather
- Persistent stylised puddles during/after rain.
- Puddles shrink over successive dry weather transitions and refill when rain returns.
- Continuous under-map character reflections revealed by puddle masks.

### World presentation
- Smooth sun/moon rendering integrated with the lighting direction.
- Procedural distant forests, hills and mountain ridges.
- Curved continuation terrain hides the hard edge/underside of loaded maps.
