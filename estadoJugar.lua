Class = require 'lib.class'

require 'estado'
require 'jugador'

EstadoJugar = Class{
    __includes = Estado
}

function EstadoJugar:init()
    self.jugador = Jugador(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 70)

    self.fondo = love.graphics.newImage("imagenes/fondoJuego.png")

    self.fuenteHUD = love.graphics.newFont("fuentes/fuentePixelart.ttf", 14)

    self.puntaje = 0
    self.vidas = 3
    self.puntajeVictoria = 100
    self.tiempoInvulnerable = 0

    -- Efectos visuales
    self.tiempoEfecto = 0
    self.tipoEfecto = nil

    -- Cargamos los sonidos de la partida
    self.musica = love.audio.newSource("sonidos/musica.wav", "stream")
    self.sonidoComer = love.audio.newSource("sonidos/comer.wav", "static")
    self.sonidoPerderVida = love.audio.newSource("sonidos/perderVida.wav", "static")

    self.musica:setLooping(true)
    self.musica:setVolume(0.08)
    self.musica:play()

    self.enemigos = {}
    self.tiempoGeneracion = 0
    self.maximoEnemigos = 8

    self:GenerarEnemigo(1)
    self:GenerarEnemigo(2)
    self:GenerarEnemigo(3)
    self:GenerarEnemigo(4)
end

function EstadoJugar:ingresar(datos)
end

function EstadoJugar:salir()
    self.musica:stop()
end

function EstadoJugar:PosicionSegura(tamano)
    local radioJugador = self.jugador.tamano / 2
    local radioEnemigo = tamano / 2

    for intento = 1, 50 do
        local x = math.random(50, love.graphics.getWidth() - 50)
        local y = math.random(50, love.graphics.getHeight() - 50)

        local diferenciaX = x - self.jugador.x
        local diferenciaY = y - self.jugador.y
        local distanciaJugador = math.sqrt(diferenciaX * diferenciaX + diferenciaY * diferenciaY)

        local distanciaMinimaJugador = radioJugador + radioEnemigo + 100

        if distanciaJugador >= distanciaMinimaJugador then
            local posicionValida = true

            for i, enemigo in ipairs(self.enemigos) do
                local diferenciaEnemigoX = x - enemigo.x
                local diferenciaEnemigoY = y - enemigo.y
                local distanciaEnemigo = math.sqrt(diferenciaEnemigoX * diferenciaEnemigoX + diferenciaEnemigoY * diferenciaEnemigoY)

                local distanciaMinimaEnemigo = radioEnemigo + enemigo.tamano / 2 + 50

                if distanciaEnemigo < distanciaMinimaEnemigo then
                    posicionValida = false
                    break
                end
            end

            if posicionValida then
                return x, y
            end
        end
    end

    -- Si no encontramos una posicion despues de varios intentos
    -- usamos una posicion aleatoria como ultimo recurso
    return math.random(50, love.graphics.getWidth() - 50), math.random(50, love.graphics.getHeight() - 50)
end

function EstadoJugar:actualizar(dt)
    if self.tiempoInvulnerable > 0 then
        self.tiempoInvulnerable = self.tiempoInvulnerable - dt
    end

    if self.tiempoEfecto > 0 then
        self.tiempoEfecto = self.tiempoEfecto - dt
    end

    self.jugador:Actualizar(dt)

    for i, enemigo in ipairs(self.enemigos) do
        enemigo:Actualizar(dt, self.jugador, self.puntaje, self.enemigos)
    end

    self:SepararEnemigos()

    self:ChequearColisiones()

    self.tiempoGeneracion = self.tiempoGeneracion + dt

    if self.tiempoGeneracion >= 3 and #self.enemigos < self.maximoEnemigos then
        self:GenerarEnemigo()
        self.tiempoGeneracion = 0
    end

    local resultado = self:ChequearFinDelJuego()

    if resultado == "victoria" then
        maquinaEstado:cambiar("victoria")
    elseif resultado == "derrota" then
        maquinaEstado:cambiar("derrota")
    end
end

function EstadoJugar:dibujar()
    local escalaX = love.graphics.getWidth() / self.fondo:getWidth()
    local escalaY = love.graphics.getHeight() / self.fondo:getHeight()

    love.graphics.draw(self.fondo, 0, 0, 0, escalaX, escalaY)

    -- Mostramos el sprite correspondiente al estado del jugador
    if self.tiempoInvulnerable > 0 then
        self.jugador:DibujarGolpeado(self.tiempoInvulnerable)
    elseif self.jugador.seMueve then
        self.jugador:DibujarMovimiento()
    else
        self.jugador:DibujarReposo()
    end

    for i, enemigo in ipairs(self.enemigos) do
        enemigo:Dibujar()
    end

    -- Mostramos la informaciom dela partida
    love.graphics.setFont(self.fuenteHUD)

    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.print("Puntaje: " .. self.puntaje .. "/" .. self.puntajeVictoria, 22, 22)
    love.graphics.print("Vidas: " .. self.vidas, 22, 47)
    love.graphics.print("Tamaño: " .. self.jugador.tamano, 22, 72)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Puntaje: " .. self.puntaje .. "/" .. self.puntajeVictoria, 20, 20)
    love.graphics.print("Vidas: " .. self.vidas, 20, 45)
    love.graphics.print("Tamaño: " .. self.jugador.tamano, 20, 70)

    -- Barra de progreso del puntaje
    local anchoBarra = 180
    local altoBarra = 10
    local progreso = self.puntaje / self.puntajeVictoria

    if progreso > 1 then
        progreso = 1
    end

    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 20, 100, anchoBarra, altoBarra)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", 20, 100, anchoBarra * progreso, altoBarra)

    -- Efecto visual cuando el jugador come o recibe daño
    if self.tiempoEfecto > 0 then
        local opacidad = self.tiempoEfecto / 0.3

        if self.tipoEfecto == "comer" then
            love.graphics.setColor(1, 1, 1, opacidad * 0.25)
        elseif self.tipoEfecto == "daño" then
            love.graphics.setColor(1, 0.1, 0.1, opacidad * 0.25)
        end

        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function EstadoJugar:SepararEnemigos()
    for i = 1, #self.enemigos do
        for j = i + 1, #self.enemigos do
            local enemigoA = self.enemigos[i]
            local enemigoB = self.enemigos[j]

            local diferenciaX = enemigoA.x - enemigoB.x
            local diferenciaY = enemigoA.y - enemigoB.y
            local distancia = math.sqrt(diferenciaX * diferenciaX + diferenciaY * diferenciaY)

            local distanciaMinima = (enemigoA.tamano + enemigoB.tamano) / 2

            if distancia > 0 and distancia < distanciaMinima then
                local diferencia = distanciaMinima - distancia

                local direccionX = diferenciaX / distancia
                local direccionY = diferenciaY / distancia

                enemigoA.x = enemigoA.x + direccionX * diferencia / 2
                enemigoA.y = enemigoA.y + direccionY * diferencia / 2

                enemigoB.x = enemigoB.x - direccionX * diferencia / 2
                enemigoB.y = enemigoB.y - direccionY * diferencia / 2
            end
        end
    end
end

function EstadoJugar:ChequearColisiones()
    for i = #self.enemigos, 1, -1 do
        local enemigo = self.enemigos[i]

        if enemigo:ColisionaCon(self.jugador) then
            if self.jugador.tamano > enemigo.tamano then
                -- El jugador come al enemigo
                self.puntaje = self.puntaje + 10
                self.jugador.tamano = self.jugador.tamano + 5

                self.tiempoEfecto = 0.15
                self.tipoEfecto = "comer"

                self.sonidoComer:stop()
                self.sonidoComer:play()

                table.remove(self.enemigos, i)

            elseif enemigo.tamano > self.jugador.tamano and self.tiempoInvulnerable <= 0 then
                -- El jugador recibe daño
                self.vidas = self.vidas - 1
                self.jugador.tamano = math.max(20, self.jugador.tamano - 10)
                self.tiempoInvulnerable = 1.5

                self.tiempoEfecto = 0.3
                self.tipoEfecto = "daño"

                self.sonidoPerderVida:stop()
                self.sonidoPerderVida:play()
            end
        end
    end
end

function EstadoJugar:ChequearFinDelJuego()
    if self.puntaje >= self.puntajeVictoria then
        return "victoria"
    end

    if self.vidas <= 0 then
        return "derrota"
    end

    return nil
end

function EstadoJugar:GenerarEnemigo(tipo)
    local tamano

    -- Contamos cuantos enemigos son mas chicos que el jugador
    local cantidadEnemigosChicos = 0

    for i, enemigo in ipairs(self.enemigos) do
        if enemigo.tamano < self.jugador.tamano - 10 then
            cantidadEnemigosChicos = cantidadEnemigosChicos + 1
        end
    end

    -- Si hay pocos enemigos que podamos comer, aumentamos la probabilidad
    -- de que aparezca uno mas chico
    local probabilidadChico = 0.65

    if cantidadEnemigosChicos < 2 then
        probabilidadChico = 0.85
    end

    if math.random() < probabilidadChico then
        -- Generamos un enemigo mas chico que el jugador
        local tamanoMaximo = math.floor(self.jugador.tamano - 15)

        if tamanoMaximo < 40 then
            tamanoMaximo = 40
        end

        tamano = math.random(40, tamanoMaximo)
    else
        -- Generamos un enemigo mas grande que el jugador
        local tamanoMinimo = math.floor(self.jugador.tamano + 15)

        if tamanoMinimo > 110 then
            tamanoMinimo = 110
        end

        if tamanoMinimo < 40 then
            tamanoMinimo = 40
        end

        tamano = math.random(tamanoMinimo, 110)
    end

    local x, y = self:PosicionSegura(tamano)

    if not tipo then
        tipo = math.random(1, 5)
    end

    if tipo == 1 then
        table.insert(self.enemigos, Medusa(x, y, tamano))
    elseif tipo == 2 then
        table.insert(self.enemigos, PezLinterna(x, y, tamano))
    elseif tipo == 3 then
        table.insert(self.enemigos, Pulpo(x, y, tamano))
    elseif tipo == 4 then
        table.insert(self.enemigos, Tortuga(x, y, tamano))
    else
        table.insert(self.enemigos, Anguila(x, y, tamano))
    end
end