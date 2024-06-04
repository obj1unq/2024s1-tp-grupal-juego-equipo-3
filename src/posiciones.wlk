import wollok.game.*

object leftDirection {

	method nextMove(position) {
		return position.left(1)
	}

	method say() {
		return 'left'
	}

	method opossite() {
		return rightDirection
	}

}

object downDirection {

	method nextMove(position) {
		return position.down(1)
	}

	method say() {
		return 'down'
	}

	method opossite() {
		return upDirection
	}

}

object rightDirection {

	method nextMove(position) {
		return position.right(1)
	}

	method opossite() {
		return leftDirection
	}

	method say() {
		return 'right'
	}

}

object upDirection {

	method nextMove(position) {
		return position.up(1)
	}

	method opossite() {
		return downDirection
	}

	method say() {
		return 'up'
	}

}

class Axis {

	method nextDirection(target, owner)

	method nextMove(owner, target) {
		return self.nextDirection(target, owner).nextMove(owner.position())
	}

}

object axisX inherits Axis {

	method distance(target, owner) {
		return (target.position().x() - owner.position().x()).abs()
	}

	override method nextDirection(target, owner) {
		if (target.position().x() > owner.position().x()) {
			return rightDirection
		} else {
			return leftDirection
		}
	}

	method opossite() {
		return axisY
	}

}

object axisY inherits Axis {

	method distance(target, owner) {
		return (target.position().y() - owner.position().y()).abs()
	}

	override method nextDirection(target, owner) {
		if (target.position().y() > owner.position().y()) {
			return upDirection
		} else {
			return downDirection
		}
	}

	method opossite() {
		return axisX
	}

}

