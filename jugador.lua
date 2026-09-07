Class = require 'lib.class'

Jugador = Class{}

function Jugador:init(x, y, tamaño)
    self.x = x
    self.y = y
    self.tamaño = tamaño
    self.velocidad = 200

    -- Cargamos el spritesheet del pez espada
    self.textura = love.graphics.newImage("imagenes/pezEspada.png")

    self.ancho = 48
    self.alto = 48

    -- Por ahora usamos solamente el primer frame
    self.quad = love.graphics.newQuad(0, 0, self.ancho, self.alto, self.textura:getWidth(), self.textura:getHeight())
end

function Jugador:Actualizar(dt)
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        self.x = self.x + self.velocidad * dt
    end

    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        self.x = self.x - self.velocidad * dt
    end

    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        self.y = self.y - self.velocidad * dt
    end

    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        self.y = self.y + self.velocidad * dt
    end

    -- Evitamos que el jugador salga de la pantalla
    local radio = self.tamaño / 2

    if self.x - radio < 0 then
        self.x = radio
    end

    if self.x + radio > love.graphics.getWidth() then
        self.x = love.graphics.getWidth() - radio
    end

    if self.y - radio < 0 then
        self.y = radio
    end

    if self.y + radio > love.graphics.getHeight() then
        self.y = love.graphics.getHeight() - radio
    end
end

function Jugador:Dibujar()
    local escala = self.tamaño / self.ancho

    love.graphics.draw(self.textura, self.quad, self.x, self.y, 0, escala, escala, self.ancho / 2, self.alto / 2)
end