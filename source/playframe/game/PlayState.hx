package playframe.game;

import flixel.tweens.misc.ColorTween;

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
	public static final scoreBgHeight:Int = 155;
	
	/**
	 * the scrolling bg
	 */
	var bg:FlxBackdrop;
	
	/**
	 * the frame with the game!!
	 */
	var playFrame:PlayFrame;
	
	/**
	 * the life counter and portrait art
	 */
	var lifeCounter:LifeCounter;
	
	/**
	 * the tween that changes the color of the game
	 */
	var colorTween:ColorTween;
	 
	/**
	 * the color of the game, currently
	 */
	var gameColor:FlxColor;
	
	/**
	 * which avatar the player is using
	 */
	public static var curAvatar:String = 'gerbo';
	
	/**
	 * how many lives you can have
	 */
	public static var maxLives:Int = 4;
	
	/**
	 * the class that handles the bpm and such
	 */
	var beatManager:BeatManager;
	
	override public function create()
	{		 
		super.create();
		
		bg = new FlxBackdrop('assets/images/bgtile.png', XY, 0, 0);
        bg.velocity.set(10, 10);
        add(bg);
		
		bgColor = FlxColor.WHITE;
		
		scoreBg = new FlxSprite().makeGraphic(FlxG.width, scoreBgHeight, 0xFF919191);
		add(scoreBg);
		
		lifeCounter = new LifeCounter();
		add(lifeCounter);
		
		changeBgColor(FlxColor.WHITE, 0.001);
		
		playFrame = new PlayFrame(0);
		add(playFrame);
		
		FlxG.sound.playMusic('assets/music/play.ogg', .3, true);
		
		beatManager = new BeatManager(90, beatHit);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		beatManager.update(elapsed);
		
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
			changeBgColor(FlxColor.PURPLE, 2);
		}
		
		updateColors();
	}
	
	/**
	 * call this to slowly fade the bg color to a new color!!
	 * @param color the color to switch to
	 */
	function changeBgColor(color:FlxColor, time:Float):Void{
		if(colorTween != null && colorTween.active){
			colorTween.cancel();
			colorTween.destroy();
		}
		
		colorTween = FlxTween.color(null, time, gameColor, color);
		
		updateColors();
	}
	
	function updateColors():Void{
		if(colorTween != null){
			gameColor = colorTween.color;
		}
		
		bg.color = gameColor;
		scoreBg.color = gameColor.getDarkened(.2);	
		
		lifeCounter.portrait.color = gameColor.getLightened(.2);
		
		for(i in lifeCounter.lives){
			i.color = gameColor.getLightened(.2);
		}
	}
	
	/**
	 * the function that gets ran when a beat is hit
	 */
	function beatHit():Void{
		lifeCounter.beatHit(1);
	}
}
