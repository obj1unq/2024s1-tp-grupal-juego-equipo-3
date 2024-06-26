import wollok.game.*
import globalConfig.*

object randomizer {

	method position() {
		return game.at((3.. limit.maxX()).anyOne(), (3 .. limit.maxY()).anyOne())
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

