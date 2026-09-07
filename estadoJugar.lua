Class = require 'lib.class'

require 'estado'
require 'jugador'

EstadoJugar = Class{
    __includes = Estado
}

function EstadoJugar:init()
    self.jugador = Jugador(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 70)

    self.puntaje = 0
    self.vidas = 3
    self.puntajeVictoria = 100
    self.tiempoInvulnerable = 0

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
end

function EstadoJugar:GenerarEnemigo(tipo)
    local x = math.random(50, love.graphics.getWidth() - 50)
    local y = math.random(50, love.graphics.getHeight() - 50)
    local tamano = math.random(40, 110)

    if not tipo then
        tipo = math.random(1, 4)
    end

    if tipo == 1 then
        table.insert(self.enemigos, Medusa(x, y, tamano))
    elseif tipo == 2 then
        table.insert(self.enemigos, PezLinterna(x, y, tamano))
    elseif tipo == 3 then
        table.insert(self.enemigos, Pulpo(x, y, tamano))
    else
        table.insert(self.enemigos, Tortuga(x, y, tamano))
    end
end

function EstadoJugar:actualizar(dt)
    if self.tiempoInvulnerable > 0 then
        self.tiempoInvulnerable = self.tiempoInvulnerable - dt
    end

    self.jugador:Actualizar(dt)

    for i, enemigo in ipairs(self.enemigos) do
        enemigo:Actualizar(dt, self.jugador)
    end

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
    self.jugador:Dibujar()

    for i, enemigo in ipairs(self.enemigos) do
        enemigo:Dibujar()
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

                table.remove(self.enemigos, i)

            elseif enemigo.tamano > self.jugador.tamano and self.tiempoInvulnerable <= 0 then
                -- El jugador recibe daño
                self.vidas = self.vidas - 1
                self.jugador.tamano = math.max(20, self.jugador.tamano - 10)
                self.tiempoInvulnerable = 1.5
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