Class = require 'lib.class'
require 'enemigos.enemigo'

Pulpo = Class {
    __includes = Enemigo
}

function Pulpo:init(x, y, tamano)
    Enemigo.init(self, x, y, tamano, "imagenes/pulpoMovimiento.png", 6)
    self.velocidad = 65
end
