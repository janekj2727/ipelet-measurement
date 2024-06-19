----------------------------------------------------------------------
-- measure lengths and angles of polyline seqments
----------------------------------------------------------------------
--[[

    This file is part of the extensible drawing editor Ipe.

    Ipe is free software; you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 3 of the License, or
    (at your option) any later version.

    Ipe is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with Ipe; if not, you can find it at
    "http://www.gnu.org/copyleft/gpl.html", or write to the Free
    Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

--]]

--[[
  This ipelet was created by JJ by modification of lenght.lua from the Dagstuhl collection.
--]]

label = "Measurement"

about = [[
Measure lengths and angles of polyline segments
]]

----------------------------------------------------------
----------------------------------------------------------
-- This is the "length" function of a single segment.
-- Change it to your needs

local function norm(v) -- v is an ipe.Vector
  return v:len() -- standard Euclidean (L2) norm
end

-- For the squared Euclidean length, uncomment the following 3 lines:

-- local function norm(v)
--   return v:sqLen()
-- end
----------------------------------------------------------
----------------------------------------------------------

-- Custom unit (default 1 pt)
-- Can be set in IPE by "Set unit"
CUSTOM_UNIT = 1

local function incorrect_input(model, s)
  model:warning("Cannot compute length", s)
end

local function incorrect_input2(model, s)
  model:warning("Cannot set unit", s)
end

function distangl(model)
  local p = model:page()
  local prim = p:primarySelection()

  if not prim then
    incorrect_input(model, "No primary selection")
    return
  end
  local points = {}
  local obj = p[prim]
  if (obj:type() ~= "path") then
    incorrect_input(model, "Primary selection is of type " ..
      obj:type() .. ", not a path")
    return
  end
  -- incorrect_input(model, obj:type()) -- works: returns path
  local shape = obj:shape()
  local lastpoint
  --model.ui:explain(shape.type)
  for ind, subpath in ipairs(shape) do
    if subpath.type ~= "curve" then
      incorrect_input(model, "Some part of selection is not a polygonal path")
      return
    end
    for i, s in ipairs(subpath) do
      if s.type ~= "segment" then
        incorrect_input(model, "Some part of selection is not a polygonal path")
        return
      end
      table.insert(points, obj:matrix() * s[1])
      lastpoint = s[2]
    end
    table.insert(points, obj:matrix() * lastpoint)
    if subpath.closed then
      table.insert(points, obj:matrix() * points[1])
    end
  end

  local outp = ""
  local vec1, vec2
  for ind3, pt3 in ipairs(points) do
    if (ind3 > 2) then
      vec1 = points[ind3 - 2] - points[ind3 - 1]
      vec2 = points[ind3] - points[ind3 - 1]
      outp = outp ..
          "angle (" ..
          ind3 - 2 ..
          ", " ..
          ind3 - 1 ..
          ", " .. ind3 .. ") = " .. math.acos((vec1 ^ vec2) / norm(vec1) / norm(vec2)) * 180 / math.pi .. "°\n"
    end
    if (ind3 > 1) then
      outp = outp .. "distance (" .. ind3 - 1 .. ", " .. ind3 .. ") = " .. norm(pt3 - points[ind3 - 1]) .. " pt"
      if (CUSTOM_UNIT ~= 1.0) then
        outp = outp .. " = " .. norm(pt3 - points[ind3 - 1])/CUSTOM_UNIT .. " custom units\n"
      else
        outp = outp .. "\n"
      end
      model.ui:explain("Custom unit = " .. CUSTOM_UNIT .. " pt")
    end
  end

  print(outp)
  --model.ui:explain(outp)
  ipeui.messageBox(model.ui:win(), "information", outp, nil, nil)
end

function setunit(model)
  local p = model:page()
  local prim = p:primarySelection()

  if not prim then
    incorrect_input(model, "No primary selection")
    return
  end
  local points = {}
  local obj = p[prim]
  if (obj:type() ~= "path") then
    incorrect_input(model, "Primary selection is of type " ..
      obj:type() .. ", not a path")
    return
  end
  -- incorrect_input(model, obj:type()) -- works: returns path
  local shape = obj:shape()
  local lastpoint
  --model.ui:explain(shape.type)
  for ind, subpath in ipairs(shape) do
    if subpath.type ~= "curve" then
      incorrect_input(model, "Some part of selection is not a polygonal path")
      return
    end
    for i, s in ipairs(subpath) do
      if s.type ~= "segment" then
        incorrect_input(model, "Some part of selection is not a polygonal path")
        return
      end
      table.insert(points, s[1])
      lastpoint = s[2]
    end
    table.insert(points, lastpoint)
    if subpath.closed then
      table.insert(points, points[1])
    end
  end

  local outp = ""
  if (#points < 2) then
    incorrect_input2(model, "Primary selection smaller then one line segment")
    return
  end
  if (#points > 2) then
    incorrect_input2(model, "Primary selection bigger than one line segment")
    return
  end
  CUSTOM_UNIT = norm(points[2] - points[1])
  local outp = "Custom unit set to " .. CUSTOM_UNIT .. "pt."
  print(outp)
  model.ui:explain(outp)
end

methods = {
  { label = "Measure distances and angles", run = distangl },
  { label = "Set unit",                     run = setunit },
}
