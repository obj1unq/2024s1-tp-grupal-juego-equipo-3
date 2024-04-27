import wollok.game.*
import main_character.*
import walls.*

object gameConfiguration {

	method init() {
		game.title("game")
		game.boardGround("background.png")
		game.height(12)
		game.width(24)
		game.cellSize(64)
		border.configurate()
		teclado.configurate()
		game.addVisual(mainCharacter)
	}

}

object teclado {

	method configurate() {
		// keyboard.any().onPressDo{ juegoPepita.chequearEstadoJuego()}
		keyboard.left().onPressDo{ mainCharacter.irA(mainCharacter.position().left(1), leftDirection)}
		keyboard.right().onPressDo{ mainCharacter.irA(mainCharacter.position().right(1), rightDirection)}
		keyboard.up().onPressDo{ mainCharacter.irA(mainCharacter.position().up(1), toptDirection)}
		keyboard.down().onPressDo{ mainCharacter.irA(mainCharacter.position().down(1), downDirection)}
		keyboard.c().onPressDo{ mainCharacter.sayDirection()}
	}

}

object border {

	method configurate() {
		//game.height(15)
		//game.width(15)
		const ancho = game.width() - 1
		const alto = game.height() - 1
		const posicionesParaGenerarMuros = []
		(0 .. ancho).forEach{ num =>
			const wall = new Obstacle()
			wall.setPosition(num, alto)
			posicionesParaGenerarMuros.add(wall)
		}
		(0 .. ancho).forEach{ num =>
			const wall = new Obstacle()
			wall.setPosition(num, 0)
			posicionesParaGenerarMuros.add(wall)
		}
		(0 .. alto).forEach{ num =>
			const wall = new Obstacle()
			wall.setPosition(ancho, num)
			posicionesParaGenerarMuros.add(wall)
		}
		(0 .. alto).forEach{ num =>
			const wall = new Obstacle()
			wall.setPosition(0, num)
			posicionesParaGenerarMuros.add(wall)
		}
			 posicionesParaGenerarMuros.forEach{ w => game.addVisualIn(w, w.position())}
	}

}

