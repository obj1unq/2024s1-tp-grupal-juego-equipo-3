import wollok.game.*
import main_character.*
import randomizer.*
import walls.*

object gameConfiguration {

	method init() {
		game.title("game")
		game.boardGround("background.png")
		game.height(16)
		game.width(20)
		game.cellSize(64)
		obstacleGeneration.configurate()
		teclado.configurate()
		game.addVisual(mainCharacter)
	}

}

object teclado {

	method configurate() {
		// keyboard.any().onPressDo{ juegoPepita.chequearEstadoJuego()}
		keyboard.left().onPressDo{ mainCharacter.irA(mainCharacter.position().left(1), leftDirection)}
		keyboard.right().onPressDo{ mainCharacter.irA(mainCharacter.position().right(1), rightDirection)}
		keyboard.up().onPressDo{ mainCharacter.irA(mainCharacter.position().up(1), topDirection)}
		keyboard.down().onPressDo{ mainCharacter.irA(mainCharacter.position().down(1), downDirection)}
		keyboard.c().onPressDo{ mainCharacter.sayDirection()}
	}

}

object obstacleGeneration {

	method configurate() {
		(0 .. 20).forEach{ i =>
			var stone = new Stone()
			game.addVisualIn(stone, randomizer.emptyPosition())
		}
	}
	
	// TODO: Agregar plantas y ladrillos a la generación aleatoria

}

/*method configurate() {
 * 	const ancho = game.width() - 2
 * 	const alto = game.height() - 2
 * 	const posicionesParaGenerarMuros = []
 * 	(0 .. ancho).forEach{ num =>
 * 		const wall = new Obstacle()
 * 		wall.setPosition(num, alto)
 * 		posicionesParaGenerarMuros.add(wall)
 * 	}
 * 	(0 .. ancho).forEach{ num =>
 * 		const wall = new Obstacle()
 * 		wall.setPosition(num, 0)
 * 		posicionesParaGenerarMuros.add(wall)
 * 	}
 * 	(0 .. alto).forEach{ num =>
 * 		const wall = new Obstacle()
 * 		wall.setPosition(ancho, num)
 * 		posicionesParaGenerarMuros.add(wall)
 * 	}
 * 	(0 .. alto).forEach{ num =>
 * 		const wall = new Obstacle()
 * 		wall.setPosition(0, num)
 * 		posicionesParaGenerarMuros.add(wall)
 * 	}
 * 		 posicionesParaGenerarMuros.forEach{ w => game.addVisualIn(w, w.position())}
 }*/
