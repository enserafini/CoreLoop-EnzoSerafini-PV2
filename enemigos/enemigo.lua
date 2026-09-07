Class = require 'lib.class'

Enemigo = Class{}

function Enemigo:init(x, y, tamano, textura)
    self.x = x
    self.y = y
    self.tamano = tamano

    self.textura = love.graphics.newImage(textura)

    -- Usamos el primer sprite de la hoja de sprites
    self.ancho = self.textura:getHeight()
    self.alto = self.textura:getHeight()

    self.quad = love.graphics.newQuad(0, 0, self.ancho, self.alto, self.textura:getWidth(), self.textura:getHeight())

    self.velocidad = 70
    self.direccionX = math.random(-1, 1)
    self.direccionY = math.random(-1, 1)
    self.tiempoMovimiento = 0
end

function Enemigo:Actualizar(dt, jugador)
    local diferenciaX = jugador.x - self.x
    local diferenciaY = jugador.y - self.y

    if self.tamano > jugador.tamano + 10 then
        -- Si es más grande, persigue al jugador
        local distancia = math.sqrt(diferenciaX * diferenciaX + diferenciaY * diferenciaY)

        if distancia > 0 then
            self.direccionX = diferenciaX / distancia
            self.direccionY = diferenciaY / distancia
        end

    elseif self.tamano < jugador.tamano - 10 then
        -- Si es más chico, escapa del jugador
        local distancia = math.sqrt(diferenciaX * diferenciaX + diferenciaY * diferenciaY)

        if distancia > 0 then
            self.direccionX = -diferenciaX / distancia
            self.direccionY = -diferenciaY / distancia
        end

    else
        -- Si tienen un tamano parecido, se mueve de forma errante
        self.tiempoMovimiento = self.tiempoMovimiento - dt

        if self.tiempoMovimiento <= 0 then
            self.direccionX = math.random(-1, 1)
            self.direccionY = math.random(-1, 1)
            self.tiempoMovimiento = 1
        end
    end

    self.x = self.x + self.direccionX * self.velocidad * dt
    self.y = self.y + self.direccionY * self.velocidad * dt

    -- Evitamos que el enemigo salga de la pantalla
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

function Enemigo:Dibujar()
    local escala = self.tamano / self.ancho

    love.graphics.draw(self.textura, self.quad, self.x, self.y, 0, escala, escala, self.ancho / 2, self.alto / 2)
end