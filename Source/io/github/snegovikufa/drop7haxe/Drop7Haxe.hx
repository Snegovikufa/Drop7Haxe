package io.github.snegovikufa.drop7haxe;


import openfl.Assets;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.Lib;


class Drop7Haxe extends Sprite {


	private var Background:Bitmap;
	private var Footer:Bitmap;
	private var Game:Drop7Game;


	public function new () {

		super ();

		initialize ();
		construct ();

		resize (Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		Lib.current.stage.addEventListener (Event.RESIZE, stage_onResize);

		#if android
		Lib.current.stage.addEventListener (KeyboardEvent.KEY_UP, stage_onKeyUp);
		#end

	}


	private function construct ():Void {

		addChild (Background);
		addChild (Game);

	}


	private function initialize ():Void {

		Background = new Bitmap (Assets.getBitmapData ("images/back.jpg"));
		Game = new Drop7Game ();

	}


	private function resize (newWidth:Int, newHeight:Int):Void {

		Background.width = newWidth;
		Background.height = newHeight;

		Game.resize (newWidth, newHeight);

	}


	private function stage_onKeyUp (event:KeyboardEvent):Void {

		#if android

		if (event.keyCode == 27) {

			event.stopImmediatePropagation ();
			Lib.exit ();

		}

		#end

	}


	private function stage_onResize (event:Event):Void {

		resize (stage.stageWidth, stage.stageHeight);

	}


}
