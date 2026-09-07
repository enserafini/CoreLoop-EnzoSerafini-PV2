Class = require 'lib.class'

MaquinaEstado = Class{}

function MaquinaEstado:init(estados)
    self.estados = estados
    self.actual = nil
end

function MaquinaEstado:cambiar(nombreEstado, parametrosIniciales)
    assert(self.estados[nombreEstado], "El estado '" .. nombreEstado .. "' no existe.")

    if self.actual then
        self.actual:salir()
    end

    self.actual = self.estados[nombreEstado]()

    if self.actual.ingresar then
        self.actual:ingresar(parametrosIniciales)
    end
end

function MaquinaEstado:actualizar(dt)
    if self.actual then
        self.actual:actualizar(dt)
    end
end

function MaquinaEstado:dibujar()
    if self.actual then
        self.actual:dibujar()
    end
end