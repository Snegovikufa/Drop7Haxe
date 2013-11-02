package io.github.snegovikufa.drop7haxe;

import Math;

class EasyMode extends GameMode
{
	public function new() {
		super ();
		nextLevel ();
	}

	public override function nextLevel(): Void {
		super.nextLevel ();
		moves = Math.round (Math.max (8, 26 - level * 2));
	}
}
