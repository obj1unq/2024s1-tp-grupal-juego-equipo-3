import wollok.game.*
import globalConfig.*

object randomizer {

	method position() {
		return game.at((1 .. limit.maxX()).anyOne(), (1 .. limit.maxY()).anyOne())
	}

	method emptyPosition() {
		const position = self.position()
		if (game.getObjectsIn(position).isEmpty()) {
			return position
		} else {
			return self.emptyPosition()
		}
	}

}

