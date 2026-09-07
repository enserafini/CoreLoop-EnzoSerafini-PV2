Class = require 'lib.class'
require 'enemigos.enemigo'

PezLinterna = Class{
    __includes = Enemigo
}

function PezLinterna:init(x, y, tamano)
    Enemigo.init(self, x, y, tamano, "imagenes/pezLinterna.png")
    self.velocidad = 80
end