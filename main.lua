require 'dependencias'

maquinaEstado = nil

function love.load()

    love.window.setTitle("PECESIN GLOTONSIN")

    love.window.setMode(960, 540)

    love.graphics.setDefaultFilter("nearest", "nearest")

    maquinaEstado = MaquinaEstado{

        titulo = function()
            return EstadoTitulo(
                "PECESIN GLOTONSIN",
                "Presiona ENTER para jugar"
            )
        end,

        jugar = function()
            return EstadoJugar()
        end

    }

    maquinaEstado:cambiar("titulo")

end

function love.update(dt)

    maquinaEstado:actualizar(dt)

end

function love.draw()

    love.graphics.clear(0.03, 0.06, 0.10)

    maquinaEstado:dibujar()

end

function love.keypressed(tecla)

    if tecla == "return" then

        maquinaEstado:cambiar("jugar")

    end

end