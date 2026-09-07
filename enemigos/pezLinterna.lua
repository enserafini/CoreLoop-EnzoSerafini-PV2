Class = require 'lib.class'
require 'enemigos.enemigo'

PezLinterna = Class {
    __includes = Enemigo
}

function PezLinterna:init(x, y, tamano)
    Enemigo.init(self, x, y, tamano, "imagenes/pezLinternaMovimiento.png", 4)
    self.velocidad = 80
end
