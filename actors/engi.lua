Actor = require("actor")

Engi = {
  _tick = 0,
  _quads = {},
  _interval = 0.05,
  _sprite_control = 0,
}

Engi.__index = Engi

setmetatable (Engi, {
  __index = Actor,
  __call = function (cls, ...)
    local self = setmetatable ({}, cls)
    self:_init (...)
    return self
  end })

function Engi:_init (args)
  assert(args.x and args.y)
  Actor._init (self, args.x, args.y)
  self:set_type ("engi")
  self:set_z_index(1)
  if args.sprites then
    self._sprites = love.graphics.newImage(args.sprites)
  end
  local width = self._sprites:getWidth() / 9
  local height = self._sprites:getHeight()
  for i = 0, 8 do
    self._quads[i] = love.graphics.newQuad(width * i, 0,
                                           width, height,
                                           self._sprites:getDimensions())
  end
  self:set_height(height * 3)
  self:set_width(width * 3)
end

function Engi:draw ()
  love.graphics.draw(self._sprites, self._quads[self._sprite_control], (self:get_x() + self:get_width()), 315, 0, -3, 3)
end

function Engi:update (dt)
  self._tick = self._tick + dt
  if self._tick > self._interval then
    self._sprite_control = (self._sprite_control + 1) % (#self._quads + 1)
    self._tick = 0
  end
  self:set_x(self:get_x() - self:get_world():get_speed() * dt)
  if self:get_x() < 0 then
    self:get_world():delete_actor(self)
  end
end

return Engi
