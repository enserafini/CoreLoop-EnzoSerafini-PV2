Class = require 'lib.class'

Enemigo = Class{}

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

    if self.direccionX == 0 and self.direccionY == 0 then
        self.direccionX = 1
    end

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

function Enemigo:Actualizar(dt, jugador, puntaje, enemigos)
    local diferenciaX = jugador.x - self.x
    local diferenciaY = jugador.y - self.y

    local direccionX = 0
    local direccionY = 0

    -- Comportamiento según el tamaño
    if self.tamano > jugador.tamano + 10 then
        -- Si es más grande, persigue al jugador
        local distancia = math.sqrt(diferenciaX * diferenciaX + diferenciaY * diferenciaY)

        if distancia > 0 then
            direccionX = diferenciaX / distancia
            direccionY = diferenciaY / distancia
        end

    elseif self.tamano < jugador.tamano - 10 then
        -- Si es más chico, escapa del jugador
        local distancia = math.sqrt(diferenciaX * diferenciaX + diferenciaY * diferenciaY)

        if distancia > 0 then
            direccionX = -diferenciaX / distancia
            direccionY = -diferenciaY / distancia
        end

    else
        -- Si tienen un tamaño parecido, se mueve de forma indiferente, pero evitando acercarse demasiado al jugador
        self.tiempoMovimiento = self.tiempoMovimiento - dt

        if self.tiempoMovimiento <= 0 then
            direccionX = math.random(-1, 1)
            direccionY = math.random(-1, 1)

            if direccionX == 0 and direccionY == 0 then
                direccionX = 1
            end

            self.tiempoMovimiento = 1
        else
            direccionX = self.direccionX
            direccionY = self.direccionY
        end
    end

    -- Evita quedar atrapados contra los bordes
    local radio = self.tamano / 2
    local margenBorde = 80

    local cercaIzquierda = self.x - radio < margenBorde
    local cercaDerecha = self.x + radio > love.graphics.getWidth() - margenBorde
    local cercaArriba = self.y - radio < margenBorde
    local cercaAbajo = self.y + radio > love.graphics.getHeight() - margenBorde

    local direccionCentroX = 0
    local direccionCentroY = 0

    if cercaIzquierda then
        direccionCentroX = direccionCentroX + 1
    elseif cercaDerecha then
        direccionCentroX = direccionCentroX - 1
    end

    if cercaArriba then
        direccionCentroY = direccionCentroY + 1
    elseif cercaAbajo then
        direccionCentroY = direccionCentroY - 1
    end

    -- Si se esta cerca de un borde, se prioriaz salir hacia el centro
    if direccionCentroX ~= 0 or direccionCentroY ~= 0 then
        direccionX = direccionX + direccionCentroX * 3
        direccionY = direccionY + direccionCentroY * 3
    end

    -- Evitamos acercarnos demasiado a otros enemigos
    local separacionX = 0
    local separacionY = 0

    for i, enemigo in ipairs(enemigos) do
        if enemigo ~= self then
            local diferenciaEnemigoX = self.x - enemigo.x
            local diferenciaEnemigoY = self.y - enemigo.y
            local distancia = math.sqrt(diferenciaEnemigoX * diferenciaEnemigoX + diferenciaEnemigoY * diferenciaEnemigoY)

            local distanciaMinima = (self.tamano + enemigo.tamano) / 2 + 15

            if distancia > 0 and distancia < distanciaMinima then
                local fuerza = (distanciaMinima - distancia) / distanciaMinima

                separacionX = separacionX + (diferenciaEnemigoX / distancia) * fuerza
                separacionY = separacionY + (diferenciaEnemigoY / distancia) * fuerza
            end
        end
    end

    direccionX = direccionX + separacionX * 2
    direccionY = direccionY + separacionY * 2

    -- Normalizamos la direccion
    local distanciaDireccion = math.sqrt(direccionX * direccionX + direccionY * direccionY)

    if distanciaDireccion > 0 then
        direccionX = direccionX / distanciaDireccion
        direccionY = direccionY / distanciaDireccion
    end

    -- Suavizamos el cambio de direccion para evitar giros bruscos
    local suavizado = 5 * dt

    if suavizado > 1 then
        suavizado = 1
    end

    self.direccionX = self.direccionX + (direccionX - self.direccionX) * suavizado
    self.direccionY = self.direccionY + (direccionY - self.direccionY) * suavizado

    local distanciaActual = math.sqrt(self.direccionX * self.direccionX + self.direccionY * self.direccionY)

    if distanciaActual > 0 then
        self.direccionX = self.direccionX / distanciaActual
        self.direccionY = self.direccionY / distanciaActual
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

    -- Animamocion del enemigo
    self.tiempoAnimacion = self.tiempoAnimacion + dt

    if self.tiempoAnimacion >= 0.12 then
        self.frameActual = self.frameActual + 1

        if self.frameActual > self.cantidadFrames then
            self.frameActual = 1
        end

        self.tiempoAnimacion = 0
    end

    -- Evitamos que el enemigo salga de la pantalla
    if self.x - radio < 0 then
        self.x = radio
    elseif self.x + radio > love.graphics.getWidth() then
        self.x = love.graphics.getWidth() - radio
    end

    if self.y - radio < 0 then
        self.y = radio
    elseif self.y + radio > love.graphics.getHeight() then
        self.y = love.graphics.getHeight() - radio
    end
end

function Enemigo:Dibujar()
    local escala = self.tamano / self.ancho
    local quad = self.quads[self.frameActual]

    local angulo = math.atan2(self.direccionY, self.direccionX)

    love.graphics.draw(self.textura, quad, self.x, self.y, angulo, escala, escala, self.ancho / 2, self.alto / 2)
end

function Enemigo:ColisionaCon(jugador)
    local diferenciaX = self.x - jugador.x
    local diferenciaY = self.y - jugador.y
    local distancia = math.sqrt(diferenciaX * diferenciaX + diferenciaY * diferenciaY)

    -- Usamos un hitbox un poco más chico que el tamaño visual para evitar colisiones injustas
    local radioEnemigo = self.tamano * 0.4
    local radioJugador = jugador.tamano * 0.4

    return distancia < radioEnemigo + radioJugador
end