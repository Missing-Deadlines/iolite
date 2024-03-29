-- MIT License
--
-- Copyright (c) 2023 Missing Deadlines (Benjamin Wrensch)
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

Math.load()
Terrain.load()
Noise.load()
Node.load()
UI.load()
Log.load()

Size = 1024
NumChunks = 128
Progress = 0.0

---Called once when the script component becomes active.
---@param entity Ref The ref of the entity the script component is attached to.
function OnActivate(entity)
  HeightmapGenerator = coroutine.create(function()
    local heightmap = {}
    local noise_scale = 0.005

    -- Divide the terrain generation into NumChunks and yield after each one
    for chunk = 1, NumChunks do
      for y = 1, Size / NumChunks do
        for x = 1, Size do
          local noise_pos = Vec4((x - 1) * noise_scale,
            (y - 1 + (chunk - 1) * Size / NumChunks) * noise_scale, 0.0, 0.0)

          local height = (Noise.simplex(noise_pos) * 0.5 + 0.5) * 0.5
          noise_pos.x = noise_pos.x * 2.0
          noise_pos.y = noise_pos.y * 2.0
          height = height + (Noise.simplex(noise_pos) * 0.5 + 0.5) * 0.25
          noise_pos.x = noise_pos.x * 2.0
          noise_pos.y = noise_pos.y * 2.0
          height = height + (Noise.simplex(noise_pos) * 0.5 + 0.5) * 0.125
          noise_pos.x = noise_pos.x * 2.0
          noise_pos.y = noise_pos.y * 2.0
          height = height + (Noise.simplex(noise_pos) * 0.5 + 0.5) * 0.125 * 0.5

          height = 0.25 + height * height

          local palette_idx = 0 + Math.floor(height * 23.0)
          local grass_height = 0.0

          -- Pixel requires:
          -- Terrain height [0, 1], grass height [0, 1], and the palette index [0, 255]
          table.insert(heightmap, Terrain.HeightmapPixel(height, grass_height, palette_idx))
        end
      end

      Progress = (chunk - 1) / NumChunks * 100
      coroutine.yield()
    end

    coroutine.yield(heightmap)
  end)
end

function DrawText(text)
  UI.push_transform(UIAnchor(0.5, 0.0), UIAnchor(0.5, 0.0), UIAnchor(0.5, 0.0), UIAnchor(0.5, 0.0), 0.0)
  UI.draw_text(text, 1, 1, 0)
  UI.pop_transform()
end

--- Called every frame.
---@param entity Ref The ref of the entity the script component is attached to.
---@param delta_t number The time (in seconds) passed since the last call to this function.
function Tick(entity, delta_t)
  -- Process the result when our async. worker has finished
  if not TerrainNode and Heightmap then
    -- Requires: The heightmap as a table, the width/height (has to be square),
    -- the name of a voxel shape to source the palette from, the maximum
    -- height in voxels, and the scale (size of a single voxel)
    TerrainNode = Terrain.generate_from_data(Heightmap, Size, "terrain", 256.0, 0.1)
  elseif not TerrainNode then
    DrawText(string.format("Generating terrain... %.2f %%", Progress))
  end

  local status, heightmap = coroutine.resume(HeightmapGenerator)
  if status then
    Heightmap = heightmap
  end
end

--- Called at the frequency of the update interval specified in the component.
---@param entity Ref The ref of the entity the script component is attached to.
---@param delta_t number The time (in seconds) passed since the last call to this function.
function Update(entity, delta_t)
end

--- Called once when the script component becomes inactive.
---@param entity Ref The ref of the entity the script component is attached to.
function OnDeactivate(entity)
end

--- Event callback
---@param entity Ref The ref of the entity the script component is attached to.
---@param events table List of all events.
function OnEvent(entity, events)
end
