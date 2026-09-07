Class = require 'lib.class'
require 'enemigos.enemigo'

Tortuga = Class{
    __includes = Enemigo
}

function Tortuga:init(x, y, tamano)
    Enemigo.init(self, x, y, tamano, "imagenes/tortuga.png")
    self.velocidad = 50
end