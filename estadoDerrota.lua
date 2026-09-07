Class = require 'lib.class'
require 'estado'

EstadoDerrota = Class{
    __includes = Estado
}

function EstadoDerrota:init()
    self.fondo = love.graphics.newImage("imagenes/fondoDerrota.png")
    self.fuente = love.graphics.newFont("fuentes/fuentePixelart.ttf", 24)

    self.sonidoDerrota = love.audio.newSource("sonidos/derrota.wav", "static")
    self.tiempoEntrada = 0
end

function EstadoDerrota:ingresar(datos)
    self.tiempoEntrada = 0

    self.sonidoDerrota:stop()
    self.sonidoDerrota:play()
end

function EstadoDerrota:salir()
end

function EstadoDerrota:actualizar(dt)
    if self.tiempoEntrada < 1 then
        self.tiempoEntrada = self.tiempoEntrada + dt
    end
end

function EstadoDerrota:dibujar()
    local escalaX = love.graphics.getWidth() / self.fondo:getWidth()
    local escalaY = love.graphics.getHeight() / self.fondo:getHeight()

    love.graphics.draw(self.fondo, 0, 0, 0, escalaX, escalaY)

    love.graphics.setFont(self.fuente)

    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.printf("PERDISTE", 2, 202, love.graphics.getWidth(), "center")
    love.graphics.printf("Presiona ENTER para volver a jugar", 2, 252, love.graphics.getWidth(), "center")

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("PERDISTE", 0, 200, love.graphics.getWidth(), "center")
    love.graphics.printf("Presiona ENTER para volver a jugar", 0, 250, love.graphics.getWidth(), "center")

    -- Especie de transicion, para que la animacion de la derrota no sea tan directa
    if self.tiempoEntrada < 1 then
        local opacidad = 1 - self.tiempoEntrada

        love.graphics.setColor(0, 0, 0, opacidad)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1, 1)
    end
end