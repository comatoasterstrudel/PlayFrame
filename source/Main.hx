package;

class Main extends Sprite
{
	public function new()
	{
		super();
		
		addChild(new FlxGame(0, 0, LoadingState));
		
		#if thirtyfps
		FlxG.drawFramerate = 30;
		FlxG.updateFramerate = 30;
		#end
		
		FlxG.mouse.visible = false;
		
		DiscordClient.initialize();
		DiscordClient.changePresence('Having fun and playing with my friends', 'Having fun and playing with my friends', 'Having fun and playing with my friends');
		
		FlxSprite.defaultAntialiasing = true;
	}
}
