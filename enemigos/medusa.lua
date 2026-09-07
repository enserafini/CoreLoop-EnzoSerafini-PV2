Class = require 'lib.class'
require 'enemigos.enemigo'

Medusa = Class {
    __includes = Enemigo
}

function Medusa:init(x, y, tamano)
    Enemigo.init(self, x, y, tamano, "imagenes/medusaMovimiento.png", 4)
    self.velocidad = 60
end
