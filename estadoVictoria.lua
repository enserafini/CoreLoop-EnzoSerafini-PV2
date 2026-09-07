Class = require 'lib.class'
require 'estado'

EstadoVictoria = Class {
    __includes = Estado
}

function EstadoVictoria:init()
end

function EstadoVictoria:ingresar(datos)
end

function EstadoVictoria:salir()
end

function EstadoVictoria:actualizar(dt)
end

function EstadoVictoria:dibujar()
    love.graphics.printf("¡GANASTE!", 0, 200, love.graphics.getWidth(), "center")
    love.graphics.printf("Presiona ENTER para volver a jugar", 0, 250, love.graphics.getWidth(), "center")
end
