package io.github.snegovikufa.drop7haxe;


import motion.Actuate;
import motion.actuators.GenericActuator;
import motion.easing.Linear;
import motion.easing.Quad;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;


class DropTile extends Tile {

	public var board:Drop7Game;

	public override function moveTo (duration:Float, targetX:Float, targetY:Float):Void {

		moving = true;

		Actuate
			.tween (this, duration, { x: targetX, y: targetY } )
			.ease (Quad.easeOut)
			.onComplete (onMoveToComplete);
	}

	private function onMoveToComplete ():Void {

		moving = false;
		
		if (board != null) {
			board.onTileDrop();
			board = null;
		}
	}
}
