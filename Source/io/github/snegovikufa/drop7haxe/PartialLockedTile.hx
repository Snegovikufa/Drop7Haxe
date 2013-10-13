
package io.github.snegovikufa.drop7haxe;

class PartialLockedTile extends Tile {
{

	public function new () {

		super ("images/part_locked.png");

	}

	public override function initialize ():Void {

		super ();
		type = -1;

	}

	public function explode() : Tile
	{
		var type = Math.round (Math.random () * (tileImages.length - 1)) + 1;
		
		var tile = new Tile (tileImages[type - 1]);
		tile.initialize ();
		tile.row = this.row;
		tile.column = this.column;
		tile.x = this.x;
		tile.y = this.y;
		return tile;
	}

}
