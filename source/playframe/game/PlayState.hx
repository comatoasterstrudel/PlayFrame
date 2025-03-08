package playframe.game;

/**
 * the state with the game!! duhh
 * starting 3/7/2025 i hope i dont die making this
 */
class PlayState extends FlxState
{
	/**
	 * the sprite that goes behind the score and lives etc
	 */
	var scoreBg:FlxSprite;

	/**
	 * how tall the scorebg should be
	 */
	public static final scoreBgHeight:Int = 120;
	
	/**
	 * the scrolling bg
	 */
	var bg:FlxBackdrop;
	
	override public function create()
	{		
		super.create();
				
		bg = new FlxBackdrop('assets/images/bgtile.png', XY, 0, 0);
        bg.velocity.set(10, 10);
        add(bg);
		
		bgColor = FlxColor.WHITE;
		
		scoreBg = new FlxSprite().makeGraphic(FlxG.width, scoreBgHeight, 0xFF734747);
		add(scoreBg);
		
		addFrames();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
	
	/**
	 * call this to add the play frames
	 */
	function addFrames():Void{
		var frame1 = new PlayFrame(-300);
		add(frame1);
		
		var frame2 = new PlayFrame(300);
		add(frame2);
	}
}
