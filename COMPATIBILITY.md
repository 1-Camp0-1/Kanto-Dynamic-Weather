# Dramatic Shape compatibility

## Supported range

`DRAMATIC_SHAPE >=1.7.2 <1.8.0`

The bridge was authored and source-verified against **Dramatic Shape 1.7.2**, the current production baseline. Earlier 1.7.0/1.7.1 builds are not declared compatible by this release.

## How the bridge works

Dramatic Shape exports its module namespace through `mod.exports.lib`. Kanto Dynamic Weather uses that export to share Dramatic Shape's map, camera, lighting, shadow and renderer modules without bundling the dependency.

The current 1.7.2 renderer does not expose a public callback inside the live voxel depth pass. The weather therefore applies narrow in-memory patches to `Sky`, `Voxel3D` and `VoxelScene` as they are loaded for the companion render path. Original files on disk are never written.

Patch application prefers narrow contextual anchors and also recognises already-applied integration blocks. The Voxel3D fog/uniform integration uses semantic anchors around `Voxel3D.fog` and `Voxel3D.cull`, because Dramatic Shape 1.7.2 changed the viewport commentary around that otherwise-stable code. If a required structural anchor is genuinely absent, the add-on still fails closed with a clear compatibility error.

## Updating for a future Dramatic Shape release

1. Test the existing add-on unchanged.
2. If all anchors still apply and visual QA passes, no Kanto Dynamic Weather release is required.
3. If an anchor fails, regenerate only the relevant patch against the new Dramatic Shape source and test it.
4. If Dramatic Shape changes its public major/minor compatibility contract (for example 1.8.x), widen the manifest range only after testing.

The weather simulation, presets and effects are deliberately isolated from this bridge so renderer compatibility work remains small.
