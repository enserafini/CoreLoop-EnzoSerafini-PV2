Class = require 'lib.class'
require 'estado'
require 'jugador'

EstadoJugar = Class{
    __includes = Estado
}

function EstadoJugar:init()
    self.jugador = Jugador(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 70)
end

function EstadoJugar:ingresar(datos)
end

function EstadoJugar:salir()
end

function EstadoJugar:actualizar(dt)
    self.jugador:Actualizar(dt)
end

function EstadoJugar:dibujar()
    self.jugador:Dibujar()
end