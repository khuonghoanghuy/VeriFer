package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxMath;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;

class PlayState extends GameState
{
	var player:FlxSprite;
	var levelMap:FlxTilemap;

	// pretty hud
	var infoTxt:FlxText;
	var score:Int = 0;

	// camera thing
	var camFollow:FlxObject;

	override public function create()
	{
		super.create();
		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.screenCenter();
		add(camFollow);

		levelMap = new FlxTilemap();
		levelMap.loadMapFromCSV("assets/maps/level1/level1.csv", FlxGraphic.fromClass(GraphicAuto), 0, 0, AUTO);
		trace(levelMap.width + " and " + levelMap.height);
		add(levelMap);

		player = new FlxSprite(FlxG.width / 2 - 5);
		player.makeGraphic(8, 8, 0xffff0000);
		player.active = true;
		player.maxVelocity.set(80, 200);
		player.acceleration.y = 200;
		player.drag.x = player.maxVelocity.x * 4;
		add(player);

		infoTxt = new FlxText(10, 10, 0, "Score: " + score, 16);
		infoTxt.active = true;
		infoTxt.setFormat(FlxAssets.FONT_DEFAULT, 16, FlxColor.WHITE, LEFT, OUTLINE_FAST, FlxColor.BLACK);
		add(infoTxt);
		FlxG.camera.follow(player, TOPDOWN, 0.15);
	}

	function updateInfoTxt()
	{
		infoTxt.text = "Score: " + FlxMath.lerp(0, score, 0.1);
	}

	override public function update(elapsed:Float)
	{
		player.acceleration.x = 0;

		if (FlxG.keys.anyPressed([LEFT, A]))
		{
			player.acceleration.x = -player.maxVelocity.x * 4;
		}
		if (FlxG.keys.anyPressed([RIGHT, D]))
		{
			player.acceleration.x = player.maxVelocity.x * 4;
		}
		if (FlxG.keys.anyJustPressed([SPACE, UP, W]) && player.isTouching(FLOOR))
		{
			player.velocity.y = -player.maxVelocity.y / 2;
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			FlxG.switchState(new EditorState());
		}

		if (FlxG.keys.justPressed.ESCAPE)
			openSubState(new PauseSubState(true));

		super.update(elapsed);
		if (FlxG.keys.justPressed.SPACE)
		{
			score += 11;
		}
		updateInfoTxt();

		FlxG.collide(levelMap, player);

		if (player.y > FlxG.height)
		{
			FlxG.resetState();
		}
	}
}
