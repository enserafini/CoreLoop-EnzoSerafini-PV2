Class = require 'lib.class'

Jugador = Class{}

function Jugador:init(x, y, tamano)
    self.x = x
    self.y = y
    self.tamano = tamano
    self.velocidad = 200

    -- Cargamos los sprites del pez espada
    self.texturaMovimiento = love.graphics.newImage("imagenes/pezEspadaMovimiento.png")
    self.texturaReposo = love.graphics.newImage("imagenes/pezEspadaReposo.png")
    self.texturaGolpeado = love.graphics.newImage("imagenes/pezEspadaGolpeado.png")

    self.ancho = 48
    self.alto = 48

    -- Frames de movimiento
    self.quadMovimiento1 = love.graphics.newQuad(0, 0, 48, 48, self.texturaMovimiento:getWidth(), self.texturaMovimiento:getHeight())
    self.quadMovimiento2 = love.graphics.newQuad(48, 0, 48, 48, self.texturaMovimiento:getWidth(), self.texturaMovimiento:getHeight())
    self.quadMovimiento3 = love.graphics.newQuad(96, 0, 48, 48, self.texturaMovimiento:getWidth(), self.texturaMovimiento:getHeight())
    self.quadMovimiento4 = love.graphics.newQuad(144, 0, 48, 48, self.texturaMovimiento:getWidth(), self.texturaMovimiento:getHeight())

    -- Frames de reposo
    self.quadReposo1 = love.graphics.newQuad(0, 0, 48, 48, self.texturaReposo:getWidth(), self.texturaReposo:getHeight())
    self.quadReposo2 = love.graphics.newQuad(48, 0, 48, 48, self.texturaReposo:getWidth(), self.texturaReposo:getHeight())
    self.quadReposo3 = love.graphics.newQuad(96, 0, 48, 48, self.texturaReposo:getWidth(), self.texturaReposo:getHeight())
    self.quadReposo4 = love.graphics.newQuad(144, 0, 48, 48, self.texturaReposo:getWidth(), self.texturaReposo:getHeight())

    -- Frames cuando recibe daño
    self.quadGolpeado1 = love.graphics.newQuad(0, 0, 48, 48, self.texturaGolpeado:getWidth(), self.texturaGolpeado:getHeight())
    self.quadGolpeado2 = love.graphics.newQuad(48, 0, 48, 48, self.texturaGolpeado:getWidth(), self.texturaGolpeado:getHeight())

    self.frameActual = 1
    self.tiempoAnimacion = 0
    self.seMueve = false

    -- Dirección hacia la que mira el pez
    self.direccion = 1
end

function Jugador:Actualizar(dt)
    self.seMueve = false

    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        self.x = self.x + self.velocidad * dt
        self.seMueve = true
        self.direccion = 1
    end

    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        self.x = self.x - self.velocidad * dt
        self.seMueve = true
        self.direccion = -1
    end

    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        self.y = self.y - self.velocidad * dt
        self.seMueve = true
    end

    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        self.y = self.y + self.velocidad * dt
        self.seMueve = true
    end

    -- Animamos el pez
    self.tiempoAnimacion = self.tiempoAnimacion + dt

    if self.tiempoAnimacion >= 0.12 then
        self.frameActual = self.frameActual + 1

        if self.frameActual > 4 then
            self.frameActual = 1
        end

        self.tiempoAnimacion = 0
    end

    -- Evitamos que el jugador salga de la pantalla
    local radio = self.tamano / 2

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

function Jugador:DibujarMovimiento()
    local quad = self.quadMovimiento1

    if self.frameActual == 2 then
        quad = self.quadMovimiento2
    elseif self.frameActual == 3 then
        quad = self.quadMovimiento3
    elseif self.frameActual == 4 then
        quad = self.quadMovimiento4
    end

    local escala = self.tamano / self.ancho

    love.graphics.draw(self.texturaMovimiento, quad, self.x, self.y, 0, escala * self.direccion, escala, self.ancho / 2, self.alto / 2)
end

function Jugador:DibujarReposo()
    local quad = self.quadReposo1

    if self.frameActual == 2 then
        quad = self.quadReposo2
    elseif self.frameActual == 3 then
        quad = self.quadReposo3
    elseif self.frameActual == 4 then
        quad = self.quadReposo4
    end

    local escala = self.tamano / self.ancho

    love.graphics.draw(self.texturaReposo, quad, self.x, self.y, 0, escala * self.direccion, escala, self.ancho / 2, self.alto / 2)
end

function Jugador:DibujarGolpeado(tiempo)
    local quad = self.quadGolpeado1

    if math.floor(tiempo * 8) % 2 == 0 then
        quad = self.quadGolpeado2
    end

    local escala = self.tamano / self.ancho

    love.graphics.draw(self.texturaGolpeado, quad, self.x, self.y, 0, escala * self.direccion, escala, self.ancho / 2, self.alto / 2)
end