package playframe.game;

import flixel.sound.FlxSound;

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
	public static var curAvatar:String = '8head';
	
	/**
	 * how many lives you can have
	 */
	public static var maxLives:Int = 4;
	
	/**
	 * how many lives you have
	 */
	var lives:Int = 0;
	
	/**
	 * the class that handles the bpm and such
	 */
	var beatManager:BeatManager;
	
	/**
	 * how fast the game is
	 */
	public static var additiveSpeed:Float = 1;
	
	/**
	 * how fast the game is
	 */
	public static var subtractiveSpeed:Float = 1;
			
	override public function create()
	{		 
		super.create();
		
		preloadThings();
		
		additiveSpeed = 1;
		subtractiveSpeed = 1;
		lives = maxLives;
		
		bg = new FlxBackdrop('assets/images/bgtile.png', XY, 0, 0);
        add(bg);
		
		scoreCam = new FlxCamera(0, 0, FlxG.width, scoreBgHeight);
		scoreCam.bgColor = FlxColor.BLACK;
		FlxG.cameras.add(scoreCam, false);
		
		scoreBg = new FlxSprite().makeGraphic(FlxG.width, scoreBgHeight, 0xFF919191);
		scoreBg.camera = scoreCam;
		add(scoreBg);
		
		scoreBgTile = new FlxBackdrop('assets/images/avatartiles/' + curAvatar + '.png', XY, 0, 0);
		scoreBgTile.alpha = .2;
		scoreBgTile.camera = scoreCam;
        add(scoreBgTile);
		
		lifeCounter = new LifeCounter();
		lifeCounter.camera = scoreCam;
		lifeCounter.updateLives(lives);
		add(lifeCounter);
		
		topScroller = new FlxBackdrop('assets/images/scorebg.png', X, 0, 0);
		topScroller.y = scoreBgHeight;
        add(topScroller);
		
		bottomScroller = new FlxBackdrop('assets/images/scorebg.png', X, 0, 0);
		bottomScroller.y = FlxG.height - bottomScroller.height;
		bottomScroller.flipY = true;
        add(bottomScroller);
		
		playFrame = new PlayFrame(0);
		add(playFrame);
		
		changeActiveMusic('play4');
		
		beatManager = new BeatManager(90, beatHit);
		
		var data = new AvatarData(curAvatar);
		
		changeBgColor(data.color, 0.001);
		
		data = null;
		
		updateSpeed(0);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		beatManager.update(elapsed);
		
		if(FlxG.keys.justPressed.ESCAPE){
			FlxG.switchState(new CharacterSelectState());	
			FlxG.sound.music.stop();
			FlxG.sound.music.time = 0;
		}
		
		if(FlxG.keys.justReleased.SEVEN){
			removeLife();
		}
		
		if(FlxG.keys.justReleased.SIX){
			updateSpeed(.1);
		}
		
		updateColors();
	}
	
	function removeLife():Void{
		var iconToShake:FlxSprite = null;
	
		for(i in lifeCounter.lives){
			if(i.ID == lives) iconToShake = i;	
		}

		lives --;
		lifeCounter.updateLives(lives);		
		FlxTween.shake(iconToShake, 0.1, .2, XY);
		
		changeActiveMusic('play' + lives);
				
		FlxG.sound.play('assets/sounds/loselife.ogg', 1);
		
		updateSpeed(0);
	}
	
	/**
	 * call this to change how fast the game is
	 * @param amount the amount to change the speed by
	 */
	function updateSpeed(amount:Float):Void{
		additiveSpeed += amount;
		subtractiveSpeed -= amount;
		
		playFrame.updateSpeed();
		
		FlxG.sound.music.pitch = additiveSpeed;
						
		bg.velocity.set(10 * additiveSpeed, 10 * additiveSpeed);
		
		scoreBgTile.velocity.set(20 * additiveSpeed, 20 * additiveSpeed);

		topScroller.velocity.set(10 * additiveSpeed, 0);

		bottomScroller.velocity.set(10 * additiveSpeed, 0);
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
			if(i.animation.curAnim.name == 'good'){
				i.color = gameColor.getLightened(.2);				
			} else {
				i.color = gameColor.getDarkened(.5);
			}
		}
		
		lifeCounter.namePlate.color = gameColor.getLightened(.2);
	}
	
	/**
	 * the function that gets ran when a beat is hit
	 */
	function beatHit():Void{
		lifeCounter.beatHit(BeatManager.globalCurBeat);
	}
		
	function changeActiveMusic(name:String):Void{
		var ogTime:Float = 0;			

		if(FlxG.sound.music != null){
			ogTime = FlxG.sound.music.time;			
		}
		
		FlxG.sound.playMusic('assets/music/' + name +  '.ogg', .3, true);
		
		FlxG.sound.music.time = ogTime;		
	}
	
	function preloadThings():Void{
		FlxG.sound.cache('assets/music/play4.ogg');
		FlxG.sound.cache('assets/music/play3.ogg');
		FlxG.sound.cache('assets/music/play2.ogg');
		FlxG.sound.cache('assets/music/play1.ogg');
	}
}
