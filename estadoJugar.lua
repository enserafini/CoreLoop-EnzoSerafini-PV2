Class = require 'lib.class'
require 'estado'
require 'jugador'

EstadoJugar = Class{
    __includes = Estado
}

function EstadoJugar:init()
    self.jugador = Jugador(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 70)

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
    self.jugador:Actualizar(dt)

    for i, enemigo in ipairs(self.enemigos) do
        enemigo:Actualizar(dt, self.jugador)
    end

    self.tiempoGeneracion = self.tiempoGeneracion + dt

    if self.tiempoGeneracion >= 3 and #self.enemigos < self.maximoEnemigos then
        self:GenerarEnemigo()
        self.tiempoGeneracion = 0
    end
end

function EstadoJugar:dibujar()
    self.jugador:Dibujar()

    for i, enemigo in ipairs(self.enemigos) do
        enemigo:Dibujar()
    end
end