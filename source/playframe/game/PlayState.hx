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
	 * the scrolling tiles behind the score
	 */
	var scoreBgTile:FlxBackdrop;
	
	/**
	 * the camera that holds the top portion of the screen
	 */
	var scoreCam:FlxCamera;
	
	/**
	 * thhe scrolling bg at the top
	 */
	var topScroller:FlxBackdrop;
	 
	/**
	 * thhe scrolling bg at the top
	 */
	var bottomScroller:FlxBackdrop;
	 
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
	public static var curAvatar:String = 'hexie';
	
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
		
		scoreCam = new FlxCamera(0, 0, FlxG.width, scoreBgHeight);
		scoreCam.bgColor = FlxColor.BLACK;
		FlxG.cameras.add(scoreCam, false);
		
		scoreBg = new FlxSprite().makeGraphic(FlxG.width, scoreBgHeight, 0xFF919191);
		scoreBg.camera = scoreCam;
		add(scoreBg);
		
		scoreBgTile = new FlxBackdrop('assets/images/avatartiles/' + curAvatar + '.png', XY, 0, 0);
		scoreBgTile.alpha = .2;
        scoreBgTile.velocity.set(20, 20);
		scoreBgTile.camera = scoreCam;
        add(scoreBgTile);
		
		lifeCounter = new LifeCounter();
		lifeCounter.camera = scoreCam;
		add(lifeCounter);
		
		topScroller = new FlxBackdrop('assets/images/scorebg.png', X, 0, 0);
		topScroller.y = scoreBgHeight;
        topScroller.velocity.set(10, 0);
        add(topScroller);
		
		bottomScroller = new FlxBackdrop('assets/images/scorebg.png', X, 0, 0);
		bottomScroller.y = FlxG.height - bottomScroller.height;
		bottomScroller.flipY = true;
        bottomScroller.velocity.set(10, 0);
        add(bottomScroller);
		
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
		
		scoreBgTile.color = gameColor;
		
		topScroller.color = gameColor.getDarkened(.3);	
		bottomScroller.color = gameColor.getDarkened(.3);	

		lifeCounter.portrait.color = gameColor.getLightened(.2);
		
		for(i in lifeCounter.lives){
			i.color = gameColor.getLightened(.2);
		}
		
		lifeCounter.namePlate.color = gameColor.getLightened(.2);
	}
	
	/**
	 * the function that gets ran when a beat is hit
	 */
	function beatHit():Void{
		lifeCounter.beatHit(BeatManager.globalCurBeat);
	}
}
