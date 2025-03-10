package;

class Main extends Sprite
{
	public function new()
	{
		super();
		
		#if forceMicrogame 
		addChild(new FlxGame(0, 0, PlayState));
		FlxG.mouse.visible = false;

		return;
		#end
		addChild(new FlxGame(0, 0, CharacterSelectState));
		
		FlxG.mouse.visible = false;
	}
}
