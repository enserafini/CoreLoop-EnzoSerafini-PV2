Class = require 'lib.class'

Enemigo = Class {}

function Enemigo:init(x, y, tamano, textura, cantidadFrames)
    self.x = x
    self.y = y
    self.tamano = tamano

    self.textura = love.graphics.newImage(textura)

    self.ancho = 48
    self.alto = 48
    self.cantidadFrames = cantidadFrames

    self.frameActual = 1
    self.tiempoAnimacion = 0

    self.velocidad = 70
    self.direccionX = math.random(-1, 1)
    self.direccionY = math.random(-1, 1)
    self.tiempoMovimiento = 0

    self.quads = {}

    for i = 1, self.cantidadFrames do
        self.quads[i] = love.graphics.newQuad(
            (i - 1) * self.ancho,
            0,
            self.ancho,
            self.alto,
            self.textura:getWidth(),
            self.textura:getHeight()
        )
    end
end

function Enemigo:Actualizar(dt, jugador, puntaje)
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
        -- Si tienen un tamaño parecido, se mueve de forma indiferente
        self.tiempoMovimiento = self.tiempoMovimiento - dt

        if self.tiempoMovimiento <= 0 then
            self.direccionX = math.random(-1, 1)
            self.direccionY = math.random(-1, 1)
            self.tiempoMovimiento = 1
        end
    end

    -- Aumentamos la velocidad a medida que avanza el puntaje
    local multiplicadorVelocidad = 1

    if puntaje >= 90 then
        multiplicadorVelocidad = 1.4
    elseif puntaje >= 60 then
        multiplicadorVelocidad = 1.25
    elseif puntaje >= 30 then
        multiplicadorVelocidad = 1.1
    end

    self.x = self.x + self.direccionX * self.velocidad * multiplicadorVelocidad * dt
    self.y = self.y + self.direccionY * self.velocidad * multiplicadorVelocidad * dt

    -- Animamos el enemigo
    self.tiempoAnimacion = self.tiempoAnimacion + dt

    if self.tiempoAnimacion >= 0.12 then
        self.frameActual = self.frameActual + 1

        if self.frameActual > self.cantidadFrames then
            self.frameActual = 1
        end

        self.tiempoAnimacion = 0
    end

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
    local quad = self.quads[self.frameActual]

    love.graphics.draw(
        self.textura,
        quad,
        self.x,
        self.y,
        0,
        escala,
        escala,
        self.ancho / 2,
        self.alto / 2
    )
end

function Enemigo:ColisionaCon(jugador)
    local diferenciaX = self.x - jugador.x
    local diferenciaY = self.y - jugador.y
    local distancia = math.sqrt(diferenciaX * diferenciaX + diferenciaY * diferenciaY)

    return distancia < (self.tamano + jugador.tamano) / 2
end
