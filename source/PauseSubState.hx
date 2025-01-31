package;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class PauseSubState extends GameSubState
{
	var arraySelect:Array<String> = ["Resume", "Restart", "Exit"];
	var groupText:FlxTypedGroup<FlxText>;
	var curSelected:Int = 0;

	override function create()
	{
		super.create();

		groupText = new FlxTypedGroup<FlxText>();
		add(groupText);

		for (i in 0...arraySelect.length)
		{
			var text:FlxText = new FlxText(20 + (i * -2), 20 + (i * 20), 0, arraySelect[i], 24);
			text.setFormat(FlxAssets.FONT_DEBUGGER, 18, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
			text.scrollFactor.set();
			text.ID = i;
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

		if (FlxG.keys.justPressed.ESCAPE)
			close();

		if (FlxG.keys.justPressed.ENTER)
		{
			switch (arraySelect[curSelected].toLowerCase())
			{
				case "resume":
					close();
				case "restart":
					close();
					FlxG.resetState();
				case "exit":
					close();
					FlxG.switchState(new MenuState());
			}
		}
	}

	function changeSelection(change:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, arraySelect.length - 1);
		groupText.forEach(function(text:FlxText)
		{
			text.text = (text.ID == curSelected) ? "> " + arraySelect[text.ID] : arraySelect[text.ID];
		});
	}
}