import wollok.game.*
import obstacles.*
import extras.*
import collectable.*

object limit {

	const property maxX = game.width() - 2
	const property minX = 1
	const property maxY = game.height() - 4
	const property minY = 1

	method in(position) {
		return position.x().between(minX, maxX) and position.y().between(minY, maxY)
	}

}

class Character {

	method canGo(position) {
		return limit.in(position) and not obstacleManager.isObstacleIn(position)
	}


	method isSolid() {
		return false
	}

	method isTakeable(){
		return false
	}
}

