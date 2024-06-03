import wollok.game.*
import posiciones.*
import globalConfig.*
import mosquito.*

object mainCharacter inherits GlobalConfig {

	var property direction = downDirection
	var property position = game.at(4, 4)

	method image() = "ch" + direction + ".png"

	method goesTo(newDirection) {
		const newPosition = newDirection.nextMove(position)
		if (self.canGo(newPosition)){
		//if (limit.in(newPosition) and not obstacleGeneration.isObstacleIn(newPosition) ) {
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
	
	method chopped(mosquito){ //VER PICADO
		mosquito.effect()
	}

}

