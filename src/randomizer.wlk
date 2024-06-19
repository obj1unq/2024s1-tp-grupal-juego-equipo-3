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

	// TODO: ver si puede irse.
	method randomNumber(min, max) {
		return min.randomUpTo(max).roundUp(0)
	}

}

