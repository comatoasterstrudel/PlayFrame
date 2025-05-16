package playframe.tran;

class ShapeTransition extends FlxTypedGroup<FlxSprite>
{
	var icon:FlxSprite;
	var bars:Array<FlxSprite> = [];
	var scaleTo:Float;

	public function new(inout:String, time:Float){
		super();

		switch (inout)
		{
			case 'in':
				icon = new FlxSprite().loadGraphic('assets/images/tran/' + PlayState.curAvatar +'.png');
				icon.antialiasing = true;
				icon.scale.set(0, 0);
				icon.updateHitbox();
				icon.screenCenter();

				scaleTo = 5;

				for (i in 0...4)
				{
					var bar = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
					switch (i)
					{
						case 0:
							bar.setGraphicSize(FlxG.width, Math.ceil((FlxG.height - icon.height) / 2));
							bar.updateHitbox();
						case 1:
							bar.setGraphicSize(Math.ceil((FlxG.width - icon.width) / 2), FlxG.height);
							bar.updateHitbox();
						case 2:
							bar.setGraphicSize(FlxG.width, Math.ceil((FlxG.height - icon.height) / 2));
							bar.updateHitbox();
						case 3:
							bar.setGraphicSize(Math.ceil((FlxG.width - icon.width) / 2), FlxG.height);
							bar.updateHitbox();
					}
					add(bar);
					bars.push(bar);
				}
				add(icon);

				FlxTween.tween(icon, {"scale.x": scaleTo, "scale.y": scaleTo}, time, {ease: FlxEase.quartIn});
			case 'out':
				icon = new FlxSprite().loadGraphic('assets/images/tran/' + PlayState.curAvatar +'.png');
				icon.antialiasing = true;
				icon.scale.x = icon.scale.y = 3;
				icon.updateHitbox();
				icon.screenCenter();

				scaleTo = 0;

				for (i in 0...4)
				{
					var bar = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
					switch (i)
					{
						case 0:
							bar.setGraphicSize(FlxG.width, Math.ceil((FlxG.height - icon.height) / 2));
							bar.updateHitbox();
						case 1:
							bar.setGraphicSize(Math.ceil((FlxG.width - icon.width) / 2), FlxG.height);
							bar.updateHitbox();
						case 2:
							bar.setGraphicSize(FlxG.width, Math.ceil((FlxG.height - icon.height) / 2));
							bar.updateHitbox();
						case 3:
							bar.setGraphicSize(Math.ceil((FlxG.width - icon.width) / 2), FlxG.height);
							bar.updateHitbox();
					}
					add(bar);
					bars.push(bar);
				}
				add(icon);

				FlxTween.tween(icon, {"scale.x": scaleTo, "scale.y": scaleTo}, time, {ease: FlxEase.quartOut});
		}
	}

	override public function draw()
	{
		icon.updateHitbox();
		icon.screenCenter();
		for (i in 0...bars.length)
		{
			switch (i)
			{
				case 0:
					bars[i].setPosition(0, icon.y - bars[i].height);
				case 1:
					bars[i].setPosition(icon.x - bars[i].width, 0);
				case 2:
					bars[i].setPosition(0, icon.y + icon.height);
				case 3:
					bars[i].setPosition(icon.x + icon.width, 0);
			}
		}
		super.draw();
	}

	override public function destroy()
	{
		icon = flixel.util.FlxDestroyUtil.destroy(icon);
		bars = null;
		super.destroy();
	}
}
