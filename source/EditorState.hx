package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxRuntimeShader;
import flixel.addons.ui.FlxInputText;
import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import openfl.Assets;
import openfl.filters.ShaderFilter;
import sys.FileSystem;
import sys.io.File;

using StringTools;

class EditorState extends GameState
{
	var previewMap:FlxTilemap;
	var loadMapPath:String = "assets/maps/level1/level1.csv";
	var placeToSave:String = "assets/maps/level1/level1.csv";
	var inputTextToType:FlxInputText;
	var mapCSVString = "";
	var boxSelected:FlxSprite;
	var fullyInfoTxt:FlxText;
	var displayFullyInfo:Bool = false;
	var camHUD:FlxCamera;

	override function create()
	{
		super.create();

		mapCSVString = File.getContent(Std.string(loadMapPath));

		previewMap = new FlxTilemap();
		previewMap.loadMapFromCSV(mapCSVString, FlxGraphic.fromClass(GraphicAuto), 0, 0, AUTO);
		add(previewMap);

		boxSelected = new FlxSprite(0, 0);
		boxSelected.makeGraphic(8, 8, 0xffff0000);
		boxSelected.active = true;
		add(boxSelected);

		camHUD = new FlxCamera();
		camHUD.bgColor = FlxColor.TRANSPARENT;
		camHUD.filters = [new ShaderFilter(new FlxRuntimeShader(Main.vhsShader))];
		FlxG.cameras.add(camHUD, false);

		fullyInfoTxt = new FlxText(2, 2, 0, "", 12);
		fullyInfoTxt.setFormat(FlxAssets.FONT_DEBUGGER, 12, FlxColor.WHITE, LEFT, OUTLINE_FAST, FlxColor.BLACK);
		fullyInfoTxt.active = true;
		fullyInfoTxt.visible = false;
		fullyInfoTxt.cameras = [camHUD];
		add(fullyInfoTxt);

		inputTextToType = new FlxInputText(2, FlxG.height - 20, 120, placeToSave, 11);
		inputTextToType.setFormat(FlxAssets.FONT_DEBUGGER, 11, FlxColor.WHITE, LEFT, OUTLINE_FAST, FlxColor.BLACK);
		inputTextToType.active = true;
		inputTextToType.visible = false;
		inputTextToType.cameras = [camHUD];
		add(inputTextToType);

		updateInfo();
	}

	override function update(elapsed:Float)
	{
		updateInfo();
		super.update(elapsed);

		if (FlxG.keys.justPressed.TAB)
			displayFullyInfo = !displayFullyInfo;
		fullyInfoTxt.visible = displayFullyInfo;
		inputTextToType.visible = displayFullyInfo;

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

		if (FlxG.mouse.pressed)
		{
			// previewMap.setTileByIndex(FlxG.keys.pressed.SHIFT ? 0 : 1, FlxG.keys.pressed.SHIFT ? 0 : 1);
			var tileIndex = previewMap.getTileIndexByCoords(boxSelected.getPosition());
			previewMap.setTileByIndex(tileIndex, FlxG.keys.pressed.SHIFT ? 0 : 1);
		}

		if (FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.S)
		{
			saveMap();
		}
		if (FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.X)
		{
			loadMap();
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.switchState(new PlayState());
		}
	}

	function updateInfo()
	{
		return fullyInfoTxt.text = 'Cam Scroll: ${FlxG.camera.scroll.x}|${FlxG.camera.scroll.y}'
			+ '\nBox: ${boxSelected.x}|${boxSelected.y}'
			+ '\nMap: ${previewMap.width}|${previewMap.height}';
	}

	function saveMap()
	{
		var csvData = mapCSVString;
		var filePath = inputTextToType.text;
		try
		{
			if (FileSystem.exists(filePath))
				File.saveContent(filePath, csvData);
			else
			{
				var dirPath = filePath.substring(0, filePath.lastIndexOf('/'));
				if (!FileSystem.exists(dirPath))
					FileSystem.createDirectory(dirPath);
				File.saveContent(filePath, csvData);
			}
			trace('save to ${inputTextToType.text}');
		}
		catch (e)
		{
			trace("Couldn't save file for this path: " + filePath + "\nError Code:" + e.message);
		}
	}
	function loadMap()
	{
		var filePath = inputTextToType.text;
		try
		{
			if (FileSystem.exists(filePath))
			{
				mapCSVString = File.getContent(filePath);
				previewMap.loadMapFromCSV(Std.string(filePath), FlxGraphic.fromClass(GraphicAuto), 0, 0, AUTO);
			}
			else
			{
				trace("Couldn't load file: " + filePath);
			}
		}
		catch (e:Dynamic)
		{
			trace("Error loading file: " + filePath + "\nError Code: " + e);
		}
	}
}