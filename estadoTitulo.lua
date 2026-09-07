Class = require 'lib.class'
require 'estado'

EstadoTitulo = Class {
    __includes = Estado
}

function EstadoTitulo:init(titulo, subtitulo)
    self.titulo = titulo
    self.subtitulo = subtitulo
end

function EstadoTitulo:ingresar(datos)
    if datos then
        self.titulo = datos.titulo or self.titulo
        self.subtitulo = datos.subtitulo or self.subtitulo
    end
end

function EstadoTitulo:salir()
end

function EstadoTitulo:actualizar(dt)
end

function EstadoTitulo:dibujar()
    love.graphics.printf(self.titulo, 0, 180, love.graphics.getWidth(), "center")
    love.graphics.printf(self.subtitulo, 0, 230, love.graphics.getWidth(), "center")
end
