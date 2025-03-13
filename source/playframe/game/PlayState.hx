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
	 * the scrolling tiles behind the score
	 */
	var scoreBgTile:FlxBackdrop;
	
	/**
	 * the camera that holds the top portion of the screen
	 */
	var scoreCam:FlxCamera;
	
	/**
	 * the camera that holds the top portion of the screen
	 */
	var scrollerCam:FlxCamera;
	 
	var speedCam:FlxCamera;
	
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
		
	/**
	 * the current microgame
	 */
	public static var curMicrogame:String = '';
	
	/**
	 * whether you have won the current microgame
	 */
	public static var wonMicrogame:Bool = true;
	
	/**
	 * the value used for the time bar
	 */
	var timeLeft:Float = 1;
	
	/**
	 * the bar that shows how long you have left during a microgame
	 */
	var timeBar:FlxBar;
	
	/**
	 * your current score
	 */
	public static var curScore:Int = 1;
	
	/**
	 * the sprite that appears when the game speeds up
	 */
	var speedSprite:FlxSprite;
	
	/**
	 * the tween that squeezes the speedSprite
	 */
	var speedTween:FlxTween;
	
	/**
	 * how many times the game has sped up
	 */
	public static var speedUps:Int = 0;
	
	/**
	 * is the game over?
	 */
	public static var gameOver:Bool = false;
	
	/**
	 * the final speed before the game ended
	 */
	public static var finalSpeed:Float = 1;
	
	/**
	 * which microgames were lost
	 */
	public static var lostMicrogames:Array<String> = [];
	
	override public function create()
	{		 
		super.create();
		
		preloadThings();
		fillMicrogames();
		
		additiveSpeed = 1;
		subtractiveSpeed = 1;
		lives = maxLives;
		curMicrogame = '';
		curScore = 0;
		speedUps = 0;
		gameOver = false;
		lostMicrogames = [];
		
		bg = new FlxBackdrop('assets/images/bgtile.png', XY, 0, 0);
        add(bg);
		
		scoreCam = new FlxCamera(0, 0, FlxG.width, scoreBgHeight);
		scoreCam.bgColor = FlxColor.BLACK;
		FlxG.cameras.add(scoreCam, false);
		
		scrollerCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		scrollerCam.bgColor = FlxColor.TRANSPARENT;
		FlxG.cameras.add(scrollerCam, false);
		
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
		
		timeBar = new FlxBar(0, scoreBgHeight, BOTTOM_TO_TOP, FlxG.width, FlxG.height - scoreBgHeight, this, 'timeLeft', 0, 1);
		timeBar.createFilledBar(FlxColor.TRANSPARENT, FlxColor.BLACK);
		timeBar.alpha = 0;
		timeBar.numDivisions = Std.int(timeBar.height);
		add(timeBar);
		
		topScroller = new FlxBackdrop('assets/images/scorebg.png', X, 0, 0);
		topScroller.y = scoreBgHeight;
		topScroller.camera = scrollerCam;
        add(topScroller);
		
		bottomScroller = new FlxBackdrop('assets/images/scorebg.png', X, 0, 0);
		bottomScroller.y = FlxG.height - bottomScroller.height;
		bottomScroller.flipY = true;
		bottomScroller.camera = scrollerCam;
        add(bottomScroller);
		
		playFrame = new PlayFrame(0);
		add(playFrame);
		playFrame.addIntroScene();
		
		speedCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		speedCam.bgColor = FlxColor.TRANSPARENT;
		FlxG.cameras.add(speedCam, false);
		
		new FlxTimer().start(2.7, function(tmr:FlxTimer)
		{
			startMicrogame(pickMicrogame());
		});
		
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
		
		if(Controls.getControl('BACK', 'RELEASE')){
			FlxG.switchState(new CharacterSelectState());	
			FlxG.sound.music.stop();
			FlxG.sound.music.time = 0;
		}
		
		#if debug
		if(FlxG.keys.justReleased.SEVEN){
			removeLife();
		}
		
		if(FlxG.keys.justReleased.SIX){
			updateSpeed(.1);
		}
		#end
		
		updateColors();
	}
	
	function startMicrogame(name:String):Void{
		curMicrogame = name;
		
		var data = new MicrogameData(name);
		
		playFrame.startMicroGame(name);
		
		changeBgColor(data.color, 1 * PlayState.subtractiveSpeed);

		new FlxTimer().start(2 * PlayState.subtractiveSpeed, function(tmr:FlxTimer)
		{
			timeLeft = 1;

			FlxTween.tween(timeBar, {alpha: .15}, 1 * PlayState.subtractiveSpeed, {ease: FlxEase.quartOut});   
			
			new FlxTimer().start(1 * PlayState.subtractiveSpeed, function(tmr:FlxTimer)
			{				
				FlxTween.tween(this, {timeLeft: 0}, data.timer * PlayState.subtractiveSpeed, {onComplete: function(f):Void{
					var data = new AvatarData(curAvatar);

					changeBgColor(data.color, 1 * PlayState.subtractiveSpeed);
					
					FlxTween.tween(timeBar, {alpha: 0}, 1 * PlayState.subtractiveSpeed, {ease: FlxEase.quartOut});   
					
					if(!wonMicrogame) {
						removeLife();
					} else {
						addPoint();
					}
					
					playFrame.endMicroGame();

					if(!gameOver){
						if(checkSpeedUp()){
							new FlxTimer().start(2 * PlayState.subtractiveSpeed, function(tmr:FlxTimer)
							{
								increaseSpeed();
							});
						}
							
						new FlxTimer().start((checkSpeedUp() ? 6.5 : 3.5) * PlayState.subtractiveSpeed, function(tmr:FlxTimer)
						{
							startMicrogame(pickMicrogame());
						});	
					}
				}});   
			});
		});
	}
	
	function increaseSpeed():Void{
		updateSpeed(.07);	
		
		var data = new AvatarData(curAvatar);
		
		var thing = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, data.color.getDarkened(.7));
		thing.alpha = 0;
		thing.camera = speedCam;
		add(thing);

		speedUps ++;
		
		speedSprite = new FlxSprite().loadGraphic( speedUps == 10 ? ('assets/images/speedupmax/' + curAvatar + '.png') : ('assets/images/speedup/' + curAvatar + '.png'));
		speedSprite.camera = speedCam;
		speedSprite.screenCenter();
		speedSprite.x -= FlxG.width;
		add(speedSprite);
		
		FlxTween.tween(thing, {alpha: .8}, 1 * PlayState.subtractiveSpeed, {ease: FlxEase.quartOut});   
		FlxTween.tween(speedSprite, {x: speedSprite.x + FlxG.width}, 1 * PlayState.subtractiveSpeed, {ease: FlxEase.quartOut});   

		new FlxTimer().start(4 * PlayState.subtractiveSpeed, function(tmr:FlxTimer)
		{
			FlxTween.tween(thing, {alpha: 0}, 1 * PlayState.subtractiveSpeed, {ease: FlxEase.quartOut}); 
			FlxTween.tween(speedSprite, {x: FlxG.width}, 1 * PlayState.subtractiveSpeed, {ease: FlxEase.quartOut});   

			new FlxTimer().start(1 * PlayState.subtractiveSpeed, function(tmr:FlxTimer)
			{
				if(speedTween != null && speedTween.active){
					speedTween.cancel();
					speedTween.destroy();
				}
				thing.destroy();
				speedSprite.destroy();
				speedSprite = null;
			});
		});
	}
	
	public static function checkSpeedUp():Bool{
		return speedUps < 10 && wonMicrogame && curScore % 5 == 0;
	}
	
	function removeLife():Void{
		lostMicrogames.push(curMicrogame);
		
		var iconToShake:FlxSprite = null;
	
		for(i in lifeCounter.lives){
			if(i.ID == lives) iconToShake = i;	
		}

		lives --;
		lifeCounter.updateLives(lives);		
		FlxTween.shake(iconToShake, 0.1, .2, XY);
		
		if(lives > 0) changeActiveMusic('play' + lives);
				
		FlxG.sound.play('assets/sounds/loselife.ogg', 1);
		
		updateSpeed(0);
		
		if(lives <= 0){
			endGame();
		}
	}
	
	var originalSpeed:Float = 1;
	
	var changePitch:Bool = true;
	
	function endGame():Void{
		gameOver = true;
				
		finalSpeed = additiveSpeed;
		
		new FlxTimer().start(1 * PlayState.subtractiveSpeed, function(tmr:FlxTimer)
		{
			originalSpeed = additiveSpeed;
			
			FlxTween.num(additiveSpeed, 0, 3, {}, function(fun:Float):Void{
				additiveSpeed = fun;
				updateSpeed(0);
			});
			
			FlxTween.num(subtractiveSpeed, 0, 3, {}, function(fun:Float):Void{
				subtractiveSpeed = fun;
				updateSpeed(0);
			});
					
			var data = new AvatarData(curAvatar);
			
			changeBgColor(data.color.getDarkened(.6), 3);
			
			new FlxTimer().start(3.5 * PlayState.subtractiveSpeed, function(tmr:FlxTimer)
			{
				persistentUpdate = true;
				persistentDraw = true;
				openSubState(new GameOverSubstate());
			});	
		});
	}
	
	function addPoint():Void{
		FlxG.sound.play('assets/sounds/win.ogg', .7);

		curScore ++;
		
		lifeCounter.addScore();
	}
	
	/**
	 * call this to change how fast the game is
	 * @param amount the amount to change the speed by
	 */
	function updateSpeed(amount:Float):Void{
		additiveSpeed += amount;
		subtractiveSpeed -= amount;
		
		playFrame.updateSpeed();
		
		if(changePitch) FlxG.sound.music.pitch = additiveSpeed;
						
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
		
		if(speedSprite != null) speedSprite.color = gameColor;
		for(i in lifeCounter.scoreSprites){
			i.color = gameColor.getLightened(.2);
		}
		
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
		
		if(speedSprite != null){
			if(speedTween != null && speedTween.active){
				speedTween.cancel();
				speedTween.destroy();
			}
			
			if(BeatManager.globalCurBeat % 2 == 0){
				speedTween = FlxTween.tween(speedSprite.scale, {x: subtractiveSpeed, y: additiveSpeed}, 1 * PlayState.subtractiveSpeed, {ease: FlxEase.quartOut});   
			} else {
				speedTween = FlxTween.tween(speedSprite.scale, {x: additiveSpeed, y: subtractiveSpeed}, 1 * PlayState.subtractiveSpeed, {ease: FlxEase.quartOut});   
			}
		}
	}
		
	function changeActiveMusic(name:String):Void{
		var ogTime:Float = 0;			

		if(FlxG.sound.music != null){
			ogTime = FlxG.sound.music.time;			
		}
		
		FlxG.sound.playMusic('assets/music/' + name +  '.ogg', .3, true);
		
		FlxG.sound.music.time = ogTime;		
	}
	
	var allMicrogames:Array<String> = [];
	var availableMicrogames:Array<String> = [];
	
	function fillMicrogames():Void{
		var data = Utilities.dataFromTextFile('assets/data/microgames.txt');

		for (i in 0...data.length)
		{
			var stuff:Array<String> = data[i].split(":");

			allMicrogames.push(stuff[0]);
		}
		
		#if forceMicrogame
		allMicrogames = [Compiler.getDefine("forceMicrogame").split('=')[0]];
		#end
		
		fillAvailableMicrogames();

		trace('Filled microgames!! ' + allMicrogames);		
	}
	
	function fillAvailableMicrogames():Void{
		for(i in allMicrogames){
			availableMicrogames.push(i);
		}	
	}
	
	function pickMicrogame():String{
		var microgame = availableMicrogames[FlxG.random.int(0,availableMicrogames.length - 1)];
		
		if(microgame == curMicrogame && allMicrogames.length > 1) return pickMicrogame(); //dont pick the same one again
		
		trace('Picked microgame!!! ' + microgame);

		availableMicrogames.remove(microgame);
		
		if(availableMicrogames.length <= 0){
			trace('Seen all microgames!!');
			
			fillAvailableMicrogames();
		}
		
		return microgame;
	}
	
	function preloadThings():Void{
		FlxG.sound.cache('assets/music/play4.ogg');
		FlxG.sound.cache('assets/music/play3.ogg');
		FlxG.sound.cache('assets/music/play2.ogg');
		FlxG.sound.cache('assets/music/play1.ogg');
	}
}
