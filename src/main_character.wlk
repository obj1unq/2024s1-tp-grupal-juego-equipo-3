import wollok.game.*
import posiciones.*
import globalConfig.*
import mosquito.*

object mainCharacter inherits Character {

	var property direction = downDirection
	var property position = game.at(4, 4)
		var property lifes = 2
	var estaInvertido = false

	method image() = "ch" + direction + ".png"

	method goesTo(newDirection) {
		const newPosition = newDirection.nextMove(position)
		if (self.canGo(newPosition)) {
			// if (limit.in(newPosition) and not obstacleGeneration.isObstacleIn(newPosition) ) {
			self.direction(newDirection)
			self.position(newPosition)
		}
	}

	method sayDirection() {
		game.say(self, direction.say())
	}

	method evadeCollide() {
		const newDirection = self.direction().opossite()
		self.goesTo(newDirection)
	}

	method collision() {
	}

	method changeMoving() {
		estaInvertido = true
	}

	method recuperarVida() {
		if (lifes < 2) {
			lifes += 1
		}
	}

	method restarVida() {
		if (lifes == 1) {
			self.morir()
		} else {
			lifes -= 1
		}
	}

	method morir() {
		game.removeVisual(self)
	// CONFIGURAR FINAL 
	}

	override method isTakeable() {
		return false
	}

}

