package playframe.menu.main;

/**
 * the main menu
 */
class MainMenuState extends FlxState 
{	
	/**
	 * the scrolling bg
	 */
	var bg:FlxBackdrop;
		
	/**
	 * the tween that switches the color of the bg
	 */
	 var colorTween:ColorTween;
	 
	/**
	 * which option is selected
	 */
	public static var curSelected:Int = 0;
	
	public static var canSelect:Bool = true;
	
	var options:Array<String> = ['play', 'config', 'scores', 'practice', 'tutorial', 'leave'];
	
	var buttons:FlxTypedGroup<MainMenuButton>;
	
	var logo:FlxSprite;
	
	var artSprite:FlxSprite;
	var artTween:FlxTween;
	
	var darkBg:FlxBackdrop;
	
	var darkBgTween:FlxTween;
	
	var mainCamera:FlxCamera;
	
	var newsCamera:FlxCamera;
	
	var camHeight:Float = 1;
	
	var newsBg:FlxBackdrop;
	
	var newsText:FlxText;
	
	public static var refresh:Bool = false;

	var topCam:FlxCamera;

	override public function create()
	{		 
		super.create();
		
		refresh = false;
		
		persistentUpdate = true;
		persistentDraw = true;
		
		canSelect = true;
		
		mainCamera = new FlxCamera();
		mainCamera.bgColor.alpha = 0;
		FlxG.cameras.add(mainCamera);
		
		newsCamera = new FlxCamera(0,FlxG.height, FlxG.width, 100, 1);
		FlxG.cameras.add(newsCamera, false);
		
		bg = new FlxBackdrop('assets/images/bgtile.png', XY, 0, 0);
		bg.velocity.set(10, 10);
        add(bg);
		
		newsBg = new FlxBackdrop('assets/images/menu/newsbg.png', XY, 0, 0);
		newsBg.velocity.set(15, 15);
		newsBg.camera = newsCamera;
        add(newsBg);
		
		darkBg = new FlxBackdrop('assets/images/menu/bgdark.png', X, 0, 0);
		darkBg.velocity.set(5, 0);
		darkBg.alpha = .7;
        add(darkBg);
		
		logo = new FlxSprite().loadGraphic('assets/images/menu/logo.png');
		logo.screenCenter(X);
		add(logo);
		
		artSprite = new FlxSprite();
		add(artSprite);
		
		buttons = new FlxTypedGroup<MainMenuButton>();
		add(buttons);
		
		//FlxG.camera.setScale(1, .5);
		
		var increment:Int = 0;
		
		for(i in options){
			var button = new MainMenuButton(i);
			button.ID = increment;
			buttons.add(button);	
			
			increment ++;
		}
		
		changeSelection();
		
		triggerNewsTicker();

		if(PlayState.practiceGame != ''){
			openSubState(new PracticeState(true));
			
			topCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
			topCam.bgColor = FlxColor.TRANSPARENT;
			FlxG.cameras.add(topCam, false);
			
			var tran = new ShapeTransition('in', .5);
			tran.camera = topCam;
			add(tran);
			
			canSelect = false;
		} else {
			topCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
			topCam.bgColor = FlxColor.TRANSPARENT;
			FlxG.cameras.add(topCam, false);
			
			var tran = new ShapeTransition('in', .5);
			tran.camera = topCam;
			add(tran);

			canSelect = false;
			
			new FlxTimer().start(.5, function(tmr:FlxTimer){
				canSelect = true;
			});	
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		FlxG.mouse.visible = false;
		
		if(refresh){
			refresh = false;
			changeSelection(0);	
		}
		
		if(canSelect){
			if(Controls.getControl('LEFT', 'RELEASE')){
				changeSelection(-1);
			}
			
			if(Controls.getControl('RIGHT', 'RELEASE')){
				changeSelection(1);
			}
			
			if(Controls.getControl('ACCEPT', 'RELEASE')){
				switch(options[curSelected]){
					case 'play':
						canSelect = false;
						
						var tran = new ShapeTransition('out', .5);
						tran.camera = topCam;
						add(tran);
						
						if(FlxG.sound.music != null){
							FlxG.sound.music.fadeOut(0.5, 0);
						}
						
						PlayState.practiceGame = '';

						new FlxTimer().start(.5, function(tmr:FlxTimer){
							FlxG.switchState(new PlayState());
						});
					case 'config':
						openSubState(new CharacterSelectState());
					case 'scores':
						openSubState(new ScoresState());
					case 'practice':
						openSubState(new PracticeState());
					case 'leave':
						Sys.exit(1);
				}
			}	
			
			if(Controls.getControl('BACK', 'RELEASE')){
				FlxG.sound.playMusic('assets/music/washing machine.ogg', 1, false);
			}
		}
		
		logo.color = bg.color;
		darkBg.color = bg.color;
		
		artSprite.screenCenter();
		darkBg.screenCenter(Y);
		
		mainCamera.setScale(1, camHeight);
		
		if(newsText != null && newsText.x + newsText.width < 0){
			endNewsTicker();
		}
	}
	
	function changeSelection(amount:Int = 0):Void{
		curSelected += amount;

		if (curSelected >= options.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = options.length - 1;
		
		var bullShit:Int = 0;

		buttons.forEachAlive(function(spr:MainMenuButton)
		{
			spr.targetX = bullShit - curSelected;
			bullShit++;

			if (spr.ID != curSelected)
			{
				spr.targetScaleX = .3;
				spr.targetScaleY = .5;
				spr.targetAlpha = .65;
			}
			else
			{
				spr.targetScaleX = .7;
				spr.targetScaleY = .5;
				spr.targetAlpha = 1;
			}
		});	
		
		
		if(PlayState.curAvatar == 'illbert'){
			changeBgColor(0xFF98DFA4);

			artSprite.loadGraphic('assets/images/menu/artillbert/' + options[curSelected] + '.png');	
			
			logo.loadGraphic('assets/images/menu/logofuckinbitchfuck.png');
		} else {
			switch(options[curSelected]){
				case 'play':
					changeBgColor(0xFFBD92D2);
				case 'config':
					changeBgColor(0xFF92D2B7);
				case 'scores':
					changeBgColor(0xFFCBCBCB);
				case 'practice':
					changeBgColor(0xFFE3F5A2);
				case 'tutorial':
					changeBgColor(0xFF9A8CEA);
				case 'leave':
					changeBgColor(0xFFD29295);
			}
			
			artSprite.loadGraphic('assets/images/menu/art/' + options[curSelected] + '.png');
			
			logo.loadGraphic('assets/images/menu/logo.png');
		}
		artSprite.scale.set(.7, .7);
		
		if(artTween != null && artTween.active){
			artTween.cancel();
			artTween.destroy();
		}
		
		artTween = FlxTween.tween(artSprite.scale, {x: .6, y: .6}, .7, {ease: FlxEase.quartOut});
		
		if(darkBgTween != null && darkBgTween.active){
			darkBgTween.cancel();
			darkBgTween.destroy();
		}
		
		darkBg.scale.y = .95;
		darkBgTween = FlxTween.tween(darkBg.scale, {y: .9}, 3, {ease: FlxEase.quartOut});
	}
		
	/**
	* call this to slowly fade the bg color to a new color!!
	* @param color the color to switch to
	*/
	function changeBgColor(color:FlxColor):Void{
		if(colorTween != null && colorTween.active){
			colorTween.cancel();
			colorTween.destroy();
		}
		
		colorTween = FlxTween.color(bg, .7, bg.color, color);
	}
	
	function startNewsTicker():Void{
		FlxTween.tween(this, {camHeight: .85}, 1.4);
		FlxTween.tween(mainCamera, {y: -50}, 1.4);
		FlxTween.tween(newsCamera, {y: FlxG.height - 100}, 1.4);
				
		newsText = new FlxText();
        newsText.setFormat('assets/fonts/Andy.ttf', 70, FlxColor.WHITE);
		newsText.camera = newsCamera;
		newsText.screenCenter(X);
		newsText.y = 20;
		add(newsText);
				
		newsText.text = getNewsText();
		
		newsText.x = FlxG.width;
		
		new FlxTimer().start(1, function(tmr:FlxTimer){
			newsText.velocity.x = -300;
			newsText.moves = true;
		});
	}
	
	function endNewsTicker():Void{
		FlxTween.tween(this, {camHeight: 1}, 1.4);
		FlxTween.tween(mainCamera, {y: 0}, 1.4);
		FlxTween.tween(newsCamera, {y: FlxG.height}, 1.4);
		
		if(newsText != null) {
			newsText.destroy();
			newsText = null;
		}
		
		new FlxTimer().start(1.4, function(tmr:FlxTimer){
			triggerNewsTicker();
		});
	}
	
	function triggerNewsTicker():Void{
		new FlxTimer().start(FlxG.random.float(8, 15), function(tmr:FlxTimer){
			startNewsTicker();
		});
	}
	
	var seenNews:Array<String> = [];
	
	function getNewsText():String{
		var text = Utilities.getListFromArray(Utilities.dataFromTextFile('assets/data/newsTicker.txt'));

		for(i in seenNews){
			text.remove(i);
		}
		
		if(text.length == 0){
			seenNews = [];
			return getNewsText();
		}
		
		var selected = text[FlxG.random.int(0, text.length - 1)];
		
		seenNews.push(selected);
		
		return selected;
	}
}