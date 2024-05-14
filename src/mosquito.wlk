import wollok.game.*
import randomizer.*
import posiciones.*

class Mosquito {

	const escenario = tablero
	var property position = randomizer.position()

	method image() = "mosquito01.png"

	method setPosition(x, y) {
		position = game.at(x, y)
	}

	method colision(mainCharacter) {
		mainCharacter.picado()
	}

	method esAtravesable() {
		return true
	}

	method moving()

}


object mosquitosManager {

	const mosquitos = [ mosquito1Factory, mosquito2Factory ]

	method crearMosquitos() {
		mosquitos.anyOne().crearMosquito()
	}

}

class Mosquito1 inherits Mosquito {

	override method moving() {
		game.onTick(2000, "", { self.move()})
	}

	method move() {
		const nuevaPosicion = self.nextMove()
		if (escenario.puedeIr(self.position(), nuevaPosicion)) {
			self.position(nuevaPosicion)
		}
	}
C:\Users\publico\git\2024s1-tp-grupal-juego-equipo-3

	method nextMove() {
		// var posiciones = [game.at(self.position().x(), (1..-1).anyOne()),
		// game.at((1..-1).anyOne(), self.position().y())  ]
		const direcciones = [ arriba, abajo, izquierda, derecha ]
		return direcciones.anyOne().siguiente(position) // posiciones.anyOne()
	}

}

class MosquitoFactory {

	method crearMosquito() {
		const mosquito = self.crear()
		game.addVisual(mosquito)
		mosquito.moving()
	}

	method crear()

}

object mosquito1Factory inherits MosquitoFactory {

	override method crear() {
		return new Mosquito1()
	}

}

object mosquito2Factory inherits MosquitoFactory {

	override method crear() {
		return new Mosquito1()
	}

}

class Mosquito2 inherits Mosquito {

}

