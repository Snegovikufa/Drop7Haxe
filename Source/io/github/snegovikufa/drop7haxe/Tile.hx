package io.github.snegovikufa.drop7haxe;

import motion.Actuate;
import motion.actuators.GenericActuator;
import motion.easing.Linear;
import motion.easing.Quad;
import openfl.Assets;
import flash.display.Bitmap;
import flash.display.Sprite;


class Tile extends Sprite {

	public var column:Int;
	public var moving:Bool;
	public var removed:Bool;
	public var row:Int;
	public var type:Int;

	public static var TileImages:Array <String> = [
		"images/1.png",
		"images/2.png",
		"images/3.png",
		"images/4.png",
		"images/5.png",
		"images/6.png",
		"images/7.png",
		];


	public function new (imagePath:String) {

		super ();

		var image = new Bitmap (Assets.getBitmapData (imagePath));
		image.smoothing = true;
		addChild (image);

		mouseChildren = false;
		buttonMode = false;

		// Currently, MouseEvent listeners are added to each Tile.
		// To make them easier to tap, add an empty fill to increase
		// the size of the hit area

		graphics.beginFill (0x000000, 0);
		graphics.drawRect (-5, -5, 66, 66);
	}


	public function initialize ():Void {

		moving = false;
		removed = false;

		mouseEnabled = true;
		buttonMode = false;

		scaleX = 1;
		scaleY = 1;
		alpha = 1;
	}


	public function moveTo (duration:Float, targetX:Float, targetY:Float):Void {

		moving = true;

		Actuate
			.tween (this, duration, { x: targetX, y: targetY } )
			.ease (Quad.easeOut)
			.onComplete (this_onMoveToComplete);
	}


	public function remove (animate:Bool = true):Void {

		if (!removed) {

			mouseEnabled = false;
			buttonMode = false;

			parent.addChildAt (this, 0);
			Actuate
				.tween (this, 0.6, { alpha: 0, scaleX: 2, scaleY: 2, x: x - width / 2, y: y - height / 2 } )
				.onComplete (this_onRemoveComplete);
		}

		removed = true;

	}


	public function explode() : Tile
	{
		return this;
	}

	// Event Handlers
	private function this_onMoveToComplete ():Void {

		moving = false;

	}

	private function this_onRemoveComplete ():Void {

		parent.removeChild (this);

	}


}
