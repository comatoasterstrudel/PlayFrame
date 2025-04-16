package;

class Main extends Sprite
{
	public function new()
	{
		super();
		
		#if forceMicrogame 
		addChild(new FlxGame(0, 0, PlayState));
		FlxG.mouse.visible = false;
		
		#if thirtyfps
		FlxG.drawFramerate = 30;
		FlxG.updateFramerate = 30;
		#end
		
		return;
		#end
		
		addChild(new FlxGame(0, 0, CharacterSelectState));
		
		#if thirtyfps
		FlxG.drawFramerate = 30;
		FlxG.updateFramerate = 30;
		#end
		
		FlxG.mouse.visible = false;
		
		DiscordClient.initialize();
		DiscordClient.changePresence('Having fun and playing with my friends', 'Having fun and playing with my friends', 'Having fun and playing with my friends');
	}
}
