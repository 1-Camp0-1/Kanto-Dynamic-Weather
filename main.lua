-- Kanto Dynamic Weather
-- Standalone companion add-on for Dramatic Shape 1.7.2+ (1.7.x).
local mod = ...

local ds = mod.find and mod.find("DRAMATIC_SHAPE") or nil
if not ds then
  error("KANTO_DYNAMIC_WEATHER: Dramatic Shape 1.7.2 or newer 1.7.x is required", 0)
end
if not (ds.exports and ds.exports.lib) then
  error("KANTO_DYNAMIC_WEATHER: installed Dramatic Shape does not expose mod.exports.lib", 0)
end

local baseV = ds.exports.lib
local W = { mod=mod, ds=ds, baseV=baseV, path=mod.path }
local own = {}

local function chunkFor(rel)
  local source = mod:read(rel)
  if not source then error("KANTO_DYNAMIC_WEATHER: missing " .. rel, 0) end
  local chunk, err = load(source, "@" .. mod.path .. "/" .. rel)
  if not chunk then error("KANTO_DYNAMIC_WEATHER: " .. rel .. " did not compile: " .. tostring(err), 0) end
  return chunk
end

local bridge
local compatBridge
function W.require(name)
  if own[name] ~= nil then return own[name] end
  if name == "CinematicAtmos" or name == "DistantWorld"
      or name == "HorizonApron" or name == "WeatherSetting" then
    own[name] = false
    local value = chunkFor("lib/" .. name .. ".lua")(W)
    if value == nil then error("KANTO_DYNAMIC_WEATHER: " .. name .. " returned nil", 0) end
    own[name] = value
    return value
  end
  if name == "Voxel3D" or name == "VoxelScene" or name == "Sky" then
    if bridge and bridge[name] then return bridge[name] end
    if compatBridge then return compatBridge.requirePatched(name) end
  end
  return baseV.require(name)
end
W.data = baseV.data

compatBridge = chunkFor("compat/dramatic_shape_1_7.lua")(W)
bridge = compatBridge.load()

local CinematicAtmos = W.require("CinematicAtmos")
local Voxel3D = bridge.Voxel3D
local VoxelScene = bridge.VoxelScene
local AntiAlias = baseV.require("AntiAlias")
local VR = baseV.require("VR")
local HordeHud = baseV.require("HordeHud")

-- Anything inside Dramatic Shape that holds the VoxelScene TABLE (not a
-- copied function) now sees the weather-aware renderer too.  This particularly
-- keeps the VR eye path coherent without altering Dramatic Shape on disk.
local baseVoxelScene = baseV.require("VoxelScene")
local originalRender = baseVoxelScene.render
baseVoxelScene.render = VoxelScene.render

local pipelines = mod.content.render_pipelines
local basePipeline = pipelines:get("voxel")
if not basePipeline then
  error("KANTO_DYNAMIC_WEATHER: Dramatic Shape did not register the voxel pipeline", 0)
end
local baseUpdate = basePipeline.update
local baseInvalidate = basePipeline.invalidate

local function sceneSize(ctx)
  if love.graphics and love.graphics.getPixelDimensions then
    local pw, ph = love.graphics.getPixelDimensions()
    if pw and ph and pw > 0 and ph > 0 then return pw, ph end
  end
  return ctx.width, ctx.height
end

local function drawWorld(ctx)
  VR.paletteFor = ctx.paletteFor
  if VR.active() then
    local sw, sh = sceneSize(ctx)
    local mirror = VR.mirror(sw, sh)
    if mirror then return mirror end
  end

  local sw, sh = sceneSize(ctx)
  local rw, rh = AntiAlias.expand(sw, sh)
  local canvas = VoxelScene.render(ctx.state, rw, rh, ctx.vw, ctx.vh, ctx.paletteFor)
  if not canvas then return nil end
  if Voxel3D.beginOverlay() then
    ctx.drawFx(function(wx, wy) return Voxel3D.project(wx, 0, wy) end,
               ctx.scale * AntiAlias.factor())
    HordeHud.drawFlat(rw, rh, ctx.scale * AntiAlias.factor())
    Voxel3D.endOverlay()
  end
  return AntiAlias.resolve(canvas, sw, sh, "world")
end

pipelines:patch("voxel", {
  update = function(dt, level)
    if baseUpdate then baseUpdate(dt, level) end
    CinematicAtmos.update(dt)
  end,
  drawWorld = drawWorld,
  invalidate = function()
    if baseInvalidate then baseInvalidate() end
    pcall(Voxel3D.invalidate)
    pcall(CinematicAtmos.invalidate)
  end,
})

local SETTINGS = {
  { CinematicAtmos.atmosphereSetting,
    "Global 3D atmosphere. FULL is the production look; LOW keeps the full weather model with fewer volumes; OFF disables the companion atmosphere." },
  { CinematicAtmos.weatherSetting,
    "DYNAMIC follows a branching weather graph. Manual CLEAR, PARTLY CLOUDY, MOSTLY CLOUDY, CLOUDY, OVERCAST, RAINING and THUNDERSTORM presets are also available." },
  { CinematicAtmos.weatherSpeedSetting,
    "Dynamic-weather pacing. NORMAL is intended for play; VERY FAST holds each state for two minutes for testing." },
  { CinematicAtmos.lightSetting,
    "Volumetric sunlight strength from 1 to 10. Level 5 is the calibrated reference." },
  { CinematicAtmos.particleDensitySetting,
    "Ambient mote density from 1 to 10. Rain and thunderstorms suppress these particles automatically." },
  { CinematicAtmos.particleScaleSetting,
    "Ambient mote scale from 1 to 10. The calibrated default is 8." },
}

local schema = {}
for _, entry in ipairs(SETTINGS) do
  schema[#schema + 1] = entry[1]:schema(entry[2])
end
mod.options:define(schema)

mod.hooks:wrap("ui.options.rows", function(next, game, rows)
  local out = next(game, rows)
  if type(out) ~= "table" then return out end
  for _, entry in ipairs(SETTINGS) do out[#out + 1] = entry[1]:row() end
  return out
end)

mod.events:on("mod.options_changed", function(payload)
  if not (payload and payload.mod == mod.id) then return end
  for _, entry in ipairs(SETTINGS) do
    if payload.key == entry[1].key then entry[1]:sync(payload.value) end
  end
end)

mod.events:on("map.reloaded", function()
  pcall(CinematicAtmos.invalidate)
end)

mod.exports.version = "1.0.3"
mod.exports.compatibility = {
  dramaticShape = tostring(ds.version or "unknown"),
  bridge = "1.7.2+ / 1.7.x",
}
