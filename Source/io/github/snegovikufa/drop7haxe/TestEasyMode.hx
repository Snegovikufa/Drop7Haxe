
package io.github.snegovikufa.drop7haxe;

class TestEasyMode extends EasyMode
{
	public override function nextLevel(): Void {
		super.nextLevel ();
		moves = Math.round (Math.max (2, 4 - level * 2));
	}

}