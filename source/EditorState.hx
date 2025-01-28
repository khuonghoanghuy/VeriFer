package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import openfl.Assets;

class EditorState extends GameState
{
	var previewMap:FlxTilemap;
	var loadMapPath:String = "assets/maps/level1/level1.csv";
	var boxSelected:FlxSprite;
	var fullyInfoTxt:FlxText;
	var displayFullyInfo:Bool = false;
	var camHUD:FlxCamera;

	override function create()
	{
		super.create();

		previewMap = new FlxTilemap();
		previewMap.loadMapFromCSV(Assets.getText(loadMapPath), FlxGraphic.fromClass(GraphicAuto), 0, 0, AUTO);
		add(previewMap);

		boxSelected = new FlxSprite(0, 0);
		boxSelected.makeGraphic(8, 8, 0xffff0000);
		boxSelected.active = true;
		add(boxSelected);

		camHUD = new FlxCamera();
		camHUD.bgColor = FlxColor.TRANSPARENT;
		FlxG.cameras.add(camHUD, false);

		fullyInfoTxt = new FlxText(2, 2, 0, "", 12);
		fullyInfoTxt.setFormat(FlxAssets.FONT_DEBUGGER, 12, FlxColor.WHITE, LEFT, OUTLINE_FAST, FlxColor.BLACK);
		fullyInfoTxt.active = true;
		fullyInfoTxt.visible = false;
		fullyInfoTxt.cameras = [camHUD];
		add(fullyInfoTxt);

		updateInfo();
	}

	override function update(elapsed:Float)
	{
		updateInfo();
		super.update(elapsed);

		if (FlxG.keys.justPressed.TAB)
			displayFullyInfo = !displayFullyInfo;
		fullyInfoTxt.visible = displayFullyInfo;

		boxSelected.x = FlxG.mouse.x - FlxG.mouse.x % 8;
		boxSelected.y = FlxG.mouse.y - FlxG.mouse.y % 8;

		// camera movement
		if (FlxG.keys.pressed.LEFT)
		{
			FlxG.camera.scroll.x -= 5;
		}
		if (FlxG.keys.pressed.RIGHT)
		{
			FlxG.camera.scroll.x += 5;
		}
		if (FlxG.keys.pressed.UP)
		{
			FlxG.camera.scroll.y -= 5;
		}
		if (FlxG.keys.pressed.DOWN)
		{
			FlxG.camera.scroll.y += 5;
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.switchState(new PlayState());
		}
	}

	function updateInfo()
	{
		return fullyInfoTxt.text = 'Cam Scroll: ${FlxG.camera.scroll.x}|${FlxG.camera.scroll.y}';
	}
}