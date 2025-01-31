package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using StringTools;

class SelectLevelState extends GameState
{
	var camFollow:FlxObject;
	var arrayListLevel:Array<Int> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
	var arrayTypeMap:Array<String> = ["First Place", "Festar"];
	var groupText:FlxTypedGroup<FlxText>;
	var typeMapText:FlxText;
	var curSelected:Int = 0;

	override function create()
	{
		super.create();

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.screenCenter(X);
		add(camFollow);

		groupText = new FlxTypedGroup<FlxText>();
		add(groupText);

		for (i in 0...arrayListLevel.length)
		{
			var text:FlxText = new FlxText(20, 20 + (i * 20), 0, "Level: " + Std.string(arrayListLevel[i]), 24);
			text.ID = i;
			text.setFormat(FlxAssets.FONT_DEBUGGER, 18, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
			groupText.add(text);
		}

		typeMapText = new FlxText(0, FlxG.height - 0.1, FlxG.width * 0.9, '', 28);
		typeMapText.scrollFactor.set();
		typeMapText.setFormat(FlxAssets.FONT_DEBUGGER, 18, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		typeMapText.autoSize = true;
		add(typeMapText);

		changeSelection(0);
		FlxG.camera.follow(camFollow, LOCKON, 0.14);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.UP)
			changeSelection(-1);
		else if (FlxG.keys.justPressed.DOWN)
			changeSelection(1);

		if (FlxG.keys.justPressed.ENTER)
		{
			PlayState.levelNumber = curSelected + 1;
			PlayState.levelType = arrayTypeMap[0].toLowerCase();
			FlxG.switchState(new PlayState());
		}

		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(new MenuState());
	}

	function changeSelection(change:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, arrayListLevel.length - 1);
		groupText.forEach(function(text:FlxText)
		{
			text.text = (text.ID == curSelected) ? "> Level: " + Std.string(arrayListLevel[text.ID]) : Std.string(arrayListLevel[text.ID]);
			if (text.ID == curSelected)
				camFollow.y = text.y;
		});
	}
}