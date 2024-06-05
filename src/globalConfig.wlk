import wollok.game.*
import obstacles.*

object limit {

    const property maxX = game.width() - 2
    const property minX = 1
    const property maxY = game.height() - 4
    const property minY = 1

}

class Character {

    method in(position) {
        return position.x().between(limit.minX(), limit.maxX()) and position.y().between(limit.minY(), limit.maxY())
    }

    method canGo(position) {
        return self.in(position) and not obstacleGeneration.isObstacleIn(position)
    }

    method isSolid() {
        return false
    }

    method isTakeable()

    method collision()

    //method spiralEffect()

}