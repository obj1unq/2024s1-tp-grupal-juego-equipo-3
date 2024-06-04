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

object axisX {

	method distance(target, owner) {
		return (target.position().x() - owner.position().x()).abs()
	}

	method nextDirection(target, owner) {
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

object axisY {

	method distance(target, owner) {
		return (target.position().y() - owner.position().y()).abs()
	}

	method nextDirection(target, owner) {
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

