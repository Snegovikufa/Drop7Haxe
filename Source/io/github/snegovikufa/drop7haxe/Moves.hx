package io.github.snegovikufa.drop7haxe;

import flash.display.Bitmap;
import flash.display.Sprite;

class Moves extends Sprite {

	private var moveSprites:Array<Move>;
	private var gameMode: GameMode;

	public function new (mode: GameMode) {

		super ();

		gameMode = mode;
		initialize ();

		mouseChildren = false;
		buttonMode = false;
	}

	private function initialize ():Void {

		moveSprites = new Array <Move> ();
		nextLevel ();
		
	}

	public function nextLevel (): Void 	{
		for (i in 0...gameMode.moves) {
			var m = new Move ();
			m.x = i * 20;
			m.scaleX = 3.0;
			m.scaleY = 3.0;

			moveSprites.push (m);
			addChild (m);
		}
	}

	public function doMove (): Void {
		var move = moveSprites.pop ();
		if (move != null)
			move.remove ();
	}

	public function count(): Int {
		return moveSprites.length;
	}
}
