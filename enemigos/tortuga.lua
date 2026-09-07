Class = require 'lib.class'
require 'enemigos.enemigo'

Tortuga = Class {
    __includes = Enemigo
}

function Tortuga:init(x, y, tamano)
    Enemigo.init(self, x, y, tamano, "imagenes/tortugaMovimiento.png", 6)
    self.velocidad = 50
end
