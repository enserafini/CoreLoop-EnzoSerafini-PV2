Class = require 'lib.class'
require 'enemigos.enemigo'

Pulpo = Class{
    __includes = Enemigo
}

function Pulpo:init(x, y, tamano)
    Enemigo.init(self, x, y, tamano, "imagenes/pulpo.png")
    self.velocidad = 65
end