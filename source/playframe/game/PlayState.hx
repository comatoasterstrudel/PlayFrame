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
	
	/**
	 * the tween that changes the color of the bg tiles
	 */
	var bgColorTween:FlxTween;
	
	/**
	 * the tween that changes the color of the score
	 */
	var scoreColorTween:FlxTween;
	 
	override public function create()
	{		
		super.create();
				
		bg = new FlxBackdrop('assets/images/bgtile.png', XY, 0, 0);
        bg.velocity.set(10, 10);
        add(bg);
		
		bgColor = FlxColor.WHITE;
		
		scoreBg = new FlxSprite().makeGraphic(FlxG.width, scoreBgHeight, 0xFF919191);
		add(scoreBg);
		
		changeBgColor(FlxColor.WHITE, 0.001);
		
		addFrames();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if(FlxG.keys.justReleased.LEFT){
			changeBgColor(FlxColor.RED, 2);
		}
		
		if(FlxG.keys.justReleased.RIGHT){
			changeBgColor(FlxColor.GREEN, 2);
		}
		
		if(FlxG.keys.justReleased.DOWN){
			changeBgColor(FlxColor.BLUE, 2);
		}
		
		if(FlxG.keys.justReleased.UP){
			changeBgColor(FlxColor.YELLOW, 2);
		}
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
	
	/**
	 * call this to slowly fade the bg color to a new color!!
	 * @param color the color to switch to
	 */
	function changeBgColor(color:FlxColor, time:Float):Void{
		if(bgColorTween != null && bgColorTween.active){
			bgColorTween.cancel();
			bgColorTween.destroy();
		}
		
		bgColorTween = FlxTween.color(bg, time, bg.color, color);

		if(scoreColorTween != null && scoreColorTween.active){
			scoreColorTween.cancel();
			scoreColorTween.destroy();
		}
		
		scoreColorTween = FlxTween.color(scoreBg, time, scoreBg.color, color.getDarkened(.2));
	}
}
