Class = require 'lib.class'
require 'estado'

EstadoDerrota = Class{
    __includes = Estado
}

function EstadoDerrota:init()
end

function EstadoDerrota:ingresar(datos)
end

function EstadoDerrota:salir()
end

function EstadoDerrota:actualizar(dt)
end

function EstadoDerrota:dibujar()
    love.graphics.printf("PERDISTE", 0, 200, love.graphics.getWidth(), "center")
    love.graphics.printf("Presiona ENTER para volver a jugar", 0, 250, love.graphics.getWidth(), "center")
end