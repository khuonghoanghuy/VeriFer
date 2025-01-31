package;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class MenuState extends GameState
{
	var arrayList:Array<String> = ["Play", "Options", "Quit"];
	var groupText:FlxTypedGroup<FlxText>;
	var curSelected:Int = 0;

	override function create()
	{
		super.create();
		groupText = new FlxTypedGroup<FlxText>();
		add(groupText);

		for (i in 0...arrayList.length)
		{
			var text = new FlxText(20 + (i * -2), 20 + (i * 20), 0, arrayList[i], 24);
			text.ID = i;
			text.scrollFactor.set();
			text.setFormat(FlxAssets.FONT_DEBUGGER, 18, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
			groupText.add(text);
		}

		changeSelection(0);
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
			switch (arrayList[curSelected].toLowerCase())
			{
				case "play":
					FlxG.switchState(new SelectLevelState());
				case "options":
					FlxG.switchState(new options.OptionsState());
				case "quit":
					SaveData.saveSettings();
					Sys.exit(0);
			}
		}
	}

	function changeSelection(change:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, arrayList.length - 1);
		groupText.forEach(function(text:FlxText)
		{
			text.text = (text.ID == curSelected) ? "> " + arrayList[text.ID] : arrayList[text.ID];
		});
	}
}