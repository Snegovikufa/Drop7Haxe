package io.github.snegovikufa.drop7haxe;

import flash.display.Sprite;
import flash.display.Bitmap;
import openfl.Assets;

class Move extends Sprite {

	public function new () {

		super ();

		var image = new Bitmap (Assets.getBitmapData ("images/move.png"));
		image.smoothing = true;
	
		addChild (image);

		mouseChildren = false;
		buttonMode = false;

	}

	public function remove () : Void {
		parent.removeChild (this);
	}

}
