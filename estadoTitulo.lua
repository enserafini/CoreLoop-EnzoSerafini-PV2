Class = require 'lib.class'
require 'estado'

EstadoTitulo = Class {
    __includes = Estado
}

function EstadoTitulo:init(titulo, subtitulo)
    self.titulo = titulo
    self.subtitulo = subtitulo

    self.fondo = love.graphics.newImage("imagenes/fondoInicio.png")

    self.fuenteTitulo = love.graphics.newFont("fuentes/fuentePixelart.ttf", 32)
    self.fuenteSubtitulo = love.graphics.newFont("fuentes/fuentePixelart.ttf", 16)

    self.musica = love.audio.newSource("sonidos/inicio.wav", "stream")
    self.musica:setLooping(true)
    self.musica:setVolume(0.08)
    self.musica:play()
end

function EstadoTitulo:ingresar(datos)
    if datos then
        self.titulo = datos.titulo or self.titulo
        self.subtitulo = datos.subtitulo or self.subtitulo
    end
end

function EstadoTitulo:salir()
    self.musica:stop()
end

function EstadoTitulo:actualizar(dt)
end

function EstadoTitulo:dibujar()
    local escalaX = love.graphics.getWidth() / self.fondo:getWidth()
    local escalaY = love.graphics.getHeight() / self.fondo:getHeight()

    love.graphics.draw(self.fondo, 0, 0, 0, escalaX, escalaY)

    -- Titulo con sombras
    love.graphics.setFont(self.fuenteTitulo)

    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.printf(self.titulo, 2, 172, love.graphics.getWidth(), "center")

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(self.titulo, 0, 170, love.graphics.getWidth(), "center")

    -- Subtitulo con sombras
    love.graphics.setFont(self.fuenteSubtitulo)

    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.printf(self.subtitulo, 2, 232, love.graphics.getWidth(), "center")

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(self.subtitulo, 0, 230, love.graphics.getWidth(), "center")
end
