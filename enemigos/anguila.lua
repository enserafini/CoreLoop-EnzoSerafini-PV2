Class = require 'lib.class'
require 'enemigos.enemigo'

Anguila = Class {
    __includes = Enemigo
}

function Anguila:init(x, y, tamano)
    Enemigo.init(self, x, y, tamano, "imagenes/anguilaMovimiento.png", 6)
    self.velocidad = 75
end
