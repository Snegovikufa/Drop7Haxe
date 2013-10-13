package io.github.snegovikufa.drop7haxe;


import motion.Actuate;
import motion.easing.Quad;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.filters.BlurFilter;
import nme.filters.DropShadowFilter;
import nme.geom.Point;
import nme.media.Sound;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
import nme.Assets;
import nme.Lib;

class Drop7Game extends Sprite {

	private static var NUM_COLUMNS:Int = 7;
	private static var NUM_ROWS:Int = 7;

	private var Background:Sprite;
	private var IntroSound:Sound;
	private var Score:TextField;
	private var Sound3:Sound;
	private var Sound4:Sound;
	private var Sound5:Sound;
	private var TileContainer:Sprite;

	private var lock:Bool;

	public var currentScale:Float;
	public var currentScore:Int;

	private var cacheMouse:Point;
	private var needToCheckMatches:Bool;
	private var currentColumn:Int;

	private var nextTile:DropTile;
	private var tiles:Array <Array <Tile>>;
	private var usedTiles:Array <Tile>;


	public function new () {

		super ();

		initialize ();
		construct ();

		newGame ();

	}

	private function addTile (row:Int, column:Int):Void {

		var tile = null;
		var type = Math.round (Math.random () * (Tile.TileImages.length - 1)) + 1;

		for (usedTile in usedTiles) {
			if (usedTile.removed && usedTile.parent == null && usedTile.type == type) {
				tile = usedTile;
			}
		}

		if (tile == null) {
			tile = new Tile (Tile.TileImages[type - 1]);
		}

		tile.initialize ();

		tile.type = type;
		tile.row = row;
		tile.column = column;
		tiles[row][column] = tile;

		var position = getPosition (row, column);
		var firstPosition = getPosition (-1, column);

		tile.x = firstPosition.x;
		tile.y = firstPosition.y;

		tile.moveTo (0.15 * (row + 1), position.x, position.y);
		Actuate.tween (tile, 0.3, { alpha: 1 } ).delay (0.15 * (row - 2)).ease (Quad.easeOut);

		TileContainer.addChild (tile);
		needToCheckMatches = true;

	}

	private function addNextTile ():Void {

		var column = currentColumn;
		
		var type = Math.round (Math.random () * (Tile.TileImages.length - 1)) + 1;
		nextTile = new DropTile (Tile.TileImages[type - 1]);

		nextTile.initialize ();

		var row = -1;

		nextTile.type = type;
		nextTile.row = row;
		nextTile.column = column;

		var position = getPosition (nextTile.row, nextTile.column);
		var firstPosition = getPosition (-1, column);

		nextTile.x = firstPosition.x;
		nextTile.y = firstPosition.y;

		nextTile.moveTo (0.15 * (row + 1), position.x, position.y);
		Actuate.tween (nextTile, 0.3, { alpha: 1 } ).delay (0.15 * (row - 2)).ease (Quad.easeOut);

		TileContainer.addChild (nextTile);
	}


	private function construct ():Void {

		var font = Assets.getFont ("fonts/FreebooterUpdated.ttf");
		var defaultFormat = new TextFormat (font.fontName, 60, 0x000000);
		defaultFormat.align = TextFormatAlign.RIGHT;

		var contentWidth = 75 * NUM_COLUMNS;

		Score.x = contentWidth - 200;
		Score.width = 200;
		Score.y = 12;
		Score.selectable = false;
		Score.defaultTextFormat = defaultFormat;
		Score.filters = [ new BlurFilter (1.5, 1.5), new DropShadowFilter (1, 45, 0, 0.2, 5, 5) ];
		Score.embedFonts = true;
		addChild (Score);

		Background.y = 85;
		Background.graphics.beginFill (0xFFFFFF, 0.4);
		Background.graphics.drawRect (0, 0, contentWidth, 75 * NUM_ROWS);
		Background.filters = [ new BlurFilter (10, 10) ];
		addChild (Background);

		TileContainer.x = 14;
		TileContainer.y = Background.y + 14;

		Lib.current.stage.addEventListener (MouseEvent.MOUSE_DOWN, stage_onMouseDown);
		Lib.current.stage.addEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
		Lib.current.stage.addEventListener (MouseEvent.MOUSE_MOVE, stage_onMouseMove);
		addChild (TileContainer);

		IntroSound = Assets.getSound ("soundTheme");
		Sound3 = Assets.getSound ("sound3");
		Sound4 = Assets.getSound ("sound4");
		Sound5 = Assets.getSound ("sound5");

	}


	private function dropTiles ():Void {

		for (column in 0...NUM_COLUMNS) {

			var spaces = 0;

			for (row in 0...NUM_ROWS) {

				var index = (NUM_ROWS - 1) - row;
				var tile = tiles[index][column];

				if (tile == null) {

					spaces++;

				} else {

					if (spaces > 0) {

						var position = getPosition (index + spaces, column);
						tile.moveTo (0.15 * spaces, position.x,position.y);

						tile.row = index + spaces;
						tiles[index + spaces][column] = tile;
						tiles[index][column] = null;

						needToCheckMatches = true;

					}
				}
			}
		}
	}

	private function dropNextTile() :Void
	{
		if (nextTile == null)
			return;

		var spaces = 0;
		var column = nextTile.column;

		for (row in 0...NUM_ROWS) {

			var tile = tiles[row][column];
			if (tile == null)
				spaces++;
			else
				break;
		}

		if (spaces > 0) {

			spaces = spaces - 1;

			var position = getPosition (spaces, column);
			nextTile.moveTo (0.15 * spaces, position.x, position.y);
			nextTile.row = spaces;
			tiles[spaces][column] = nextTile;

			needToCheckMatches = true;
		}

		nextTile = null;
	}


	private function findMatches (byRow:Bool, accumulateScore:Bool = true):Array <Tile> {

		var matchedTiles = new Array <Tile> ();

		var max:Int;
		var secondMax:Int;

		if (byRow) {

			max = NUM_ROWS;
			secondMax = NUM_COLUMNS;

		} else {

			max = NUM_COLUMNS;
			secondMax = NUM_ROWS;

		}

		for (index in 0...max) {

			var matches = 0;
			var foundTiles = new Array <Tile> ();
			var previousType = -1;

			for (secondIndex in 0...secondMax) {

				var tile:Tile;
				if (byRow)
					tile = tiles[index][secondIndex];
				else
					tile = tiles[secondIndex][index];

				if (tile != null && !tile.moving)
					foundTiles.push (tile);
				else {
					for (tile in foundTiles)
						if (tile.type == foundTiles.length)
							matchedTiles.push(tile);
					foundTiles = new Array <Tile> ();
				}
			}

			for (tile in foundTiles)
				if (tile.type == foundTiles.length)
					matchedTiles.push(tile);
		}

		return matchedTiles;

	}

	private function getPosition (row:Int, column:Int):Point {
		return new Point (column * (57 + 16), row * (57 + 16));
	}

	private function getColumn(p:Point): Int
	{
		return Math.round((p.x - this.x) / (57 + 16));
	}


	private function initialize ():Void {

		currentScale = 1;
		currentScore = 0;

		tiles = new Array <Array <Tile>> ();
		usedTiles = new Array <Tile> ();

		for (row in 0...NUM_ROWS) {
			tiles[row] = new Array <Tile> ();
			for (column in 0...NUM_COLUMNS) {
				tiles[row][column] = null;
			}
		}

		Background = new Sprite ();
		Score = new TextField ();
		TileContainer = new Sprite ();
	}


	public function newGame ():Void {

		lock = true;
		currentScore = 0;
		Score.text = "0";

		for (row in 0...NUM_ROWS)
			for (column in 0...NUM_COLUMNS)
				removeTile (row, column);

		for (row in 0...2)
			for (column in 0...NUM_COLUMNS)
				addTile (row, column);

		IntroSound.play ();

		removeEventListener (Event.ENTER_FRAME, this_onEnterFrame);
		addEventListener (Event.ENTER_FRAME, this_onEnterFrame);

		currentColumn = 0;
		addNextTile ();
		lock = false;
	}


	public function removeTile (row:Int, column:Int):Void {

		var tile = tiles[row][column];

		if (tile != null) {
			tile.remove ();
			usedTiles.push (tile);
		}

		tiles[row][column] = null;
	}


	public function resize (newWidth:Int, newHeight:Int):Void {

		var maxWidth = newWidth * 0.90;
		var maxHeight = newHeight * 0.86;

		currentScale = 1;
		scaleX = 1;
		scaleY = 1;

		var currentWidth = width;
		var currentHeight = height;

		if (currentWidth > maxWidth || currentHeight > maxHeight) {

			var maxScaleX = maxWidth / currentWidth;
			var maxScaleY = maxHeight / currentHeight;

			if (maxScaleX < maxScaleY) {

				currentScale = maxScaleX;

			} else {

				currentScale = maxScaleY;

			}

			scaleX = currentScale;
			scaleY = currentScale;

		}

		x = newWidth / 2 - (currentWidth * currentScale) / 2;

	}


	// Event Handlers

	private function stage_onMouseUp (event:MouseEvent):Void {

		currentColumn = getColumn(new Point(event.stageX, event.stageY));

		if (currentColumn >= 0 && currentColumn < NUM_COLUMNS)
		{
			if (nextTile != null) {
				nextTile.board = this;
				dropNextTile ();
			}
		}

	}

	private function this_onEnterFrame (event:Event):Void {

		if (needToCheckMatches) {

			var matchedTiles = new Array <Tile> ();
			matchedTiles = matchedTiles.concat (findMatches (true));
			matchedTiles = matchedTiles.concat (findMatches (false));


			if (matchedTiles.length > 0) {
				Score.text = Std.string (currentScore);

				for (tile in matchedTiles) {
					explodeTiles (tile.row, tile.column);
					removeTile (tile.row, tile.column);
				}
			}

			dropTiles ();
		}

	}

	private function explodeTiles (row:Int, column:Int)
	{

		explodeTile (row, column - 1);
		explodeTile (row, column + 1);
		explodeTile (row - 1, column);
		explodeTile (row + 1, column);

	}

	private function explodeTile (row:Int, column:Int): Void
	{

		if (row < 0 || row >= NUM_ROWS)
			return;

		if (column < 0 || column >= NUM_COLUMNS)
			return;

		
		var tile = tiles[row][column];
		if (tile != null) {

			var newTile = tile.explode ();
			if (newTile != tile) {
				tile.remove ();
				tiles[row][column] = newTile;
				TileContainer.addChild (newTile);
			}

		}

	}

	private function TileContainer_onMouseDown (event:MouseEvent):Void {

		currentColumn = getColumn(new Point(event.stageX, event.stageY));

	}

	private function stage_onMouseDown (event:MouseEvent):Void {

		currentColumn = getColumn(new Point(event.stageX, event.stageY));

	}

	private function stage_onMouseMove (event:MouseEvent): Void {

		var point = new Point (event.stageX, event.stageY);
		moveNextTile (point);

	}

	private function moveNextTile (point: Point): Void
	{

		if (nextTile == null)
			return;

		var column = getColumn (point);
		if (column >= 0 && column < NUM_COLUMNS) {
			var position = getPosition (nextTile.row, column);
			nextTile.column = column;
			nextTile.x = position.x;
			nextTile.y = position.y;
		}

	}

	public function onTileDrop()
	{

		addNextTile ();
		needToCheckMatches = true;

	}
}
