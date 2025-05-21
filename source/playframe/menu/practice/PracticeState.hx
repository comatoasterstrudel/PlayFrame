package playframe.menu.practice;

/**
 * the menu where you pick a microgame to practice
 */
class PracticeState extends FlxSubState 
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
	 * the list of micros
	 */
	var micros:Array<String> = [];
	
	/**
	 * which option is selected
	 */
	public static var curSelected:Int = 0;
	
	var busy:Bool = true;
	
	var optionTexts:FlxTypedGroup<PracticeText>;
	
	var fast:Bool = false;
	
	var screenies:Array<FlxSprite> = [];
	var screentweens:Array<FlxTween> = [];
	
	public function new(fast:Bool = false):Void{
		super();
		
		this.fast = fast;
	}
	
	override public function create()
	{		 
		super.create();

		MainMenuState.canSelect = false;
		
		formList();
				
		bg = new FlxBackdrop('assets/images/bgtile.png', XY, 0, 0);
		bg.velocity.set(10, 10);
        add(bg);
				
		optionTexts = new FlxTypedGroup<PracticeText>();
		add(optionTexts);
        
        for (i in 0...micros.length)
		{
            var data = new MicrogameData(micros[i]);

			var text:PracticeText = new PracticeText(0, 0, data.text);
			text.screenCenter(X);
			text.setFormat('assets/fonts/Andy.ttf', 50, FlxColor.WHITE, CENTER);
			text.ID = i;
			text.color = data.color.getLightened(.6);
			optionTexts.add(text);
			
			var text2:SmallPracticeText = new SmallPracticeText('FT. ' + data.author, text);
			text2.screenCenter(X);
			text2.setFormat('assets/fonts/Andy.ttf', 25, FlxColor.WHITE, CENTER);
			text2.ID = i;
			text2.color = data.color.getLightened(.3);
			add(text2);
		}
		
        changeSelection();
		
		for(i in this.members){
			try {
				Reflect.setProperty(i, 'alpha', 0);
				try {
					FlxTween.tween(i, {alpha: 1}, fast ? 0.0000001 : .5, {ease: FlxEase.quartOut, onComplete: function(F):Void{
						busy = false;
					}});	
				} catch(e:Dynamic) {
				}
			} catch (e:Dynamic) {
				//
			}
		}	
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if(!busy){
			if(Controls.getControl('UP', 'RELEASE')){
				changeSelection(-1);
			}
			
			if(Controls.getControl('DOWN', 'RELEASE')){
				changeSelection(1);
			}
			
			if(Controls.getControl('BACK', 'RELEASE')){
				busy = true;
				
				killTweens();
				
				for(i in screenies){					
					FlxTween.tween(i, {x: FlxG.width}, .5 + (0.3 * i.ID), {ease: FlxEase.quartOut});
				}		
		
				optionTexts.forEach(function(spr:PracticeText)
				{
					spr.targetX = (-spr.width - 400);
				});
				
				for(i in this.members){
					try {
						Reflect.setProperty(i, 'alpha', 1);
						try {
							FlxTween.tween(i, {alpha: 0}, .5, {ease: FlxEase.quartOut, onComplete: function(F):Void{
								close();
								MainMenuState.canSelect = true;
							}});	
						} catch(e:Dynamic) {
						}
					} catch (e:Dynamic) {
					}
				}
			}
			
			if(Controls.getControl('ACCEPT', 'RELEASE')){
				PlayState.practiceGame = micros[curSelected];
				
				busy = true;
				
				var topCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
				topCam.bgColor = FlxColor.TRANSPARENT;
				FlxG.cameras.add(topCam, false);
		
				var tran = new ShapeTransition('out', .5);
				tran.camera = topCam;
				add(tran);
				
				if(FlxG.sound.music != null){
					FlxG.sound.music.fadeOut(0.5, 0);
				}
				
				new FlxTimer().start(.5, function(tmr:FlxTimer){
					FlxG.switchState(new PlayState());
				});
			}
		}		
	}
	
	function changeSelection(amount:Int = 0):Void{
		curSelected += amount;

		if (curSelected >= micros.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = micros.length - 1;
		
	    var data = new MicrogameData(micros[curSelected]);

		changeBgColor(data.color.getDarkened(.6));
		
		var bullShit = 0;

		optionTexts.forEach(function(spr:PracticeText)
		{
			spr.targetY = bullShit - curSelected;
			bullShit++;

			if (micros[spr.ID] != micros[curSelected])
			{
                spr.targetX = 120;

				spr.alpha = 0.5;
			}
			else
			{
                spr.targetX = 210;
				spr.alpha = 1;
			}
		});
		
		doScreenies();
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
		
		colorTween = FlxTween.color(bg, .3, bg.color, color);
	}
	
	function doScreenies():Void{
		killTweens();
		
		for(i in screenies){
			i.destroy();
		}	
		
		screenies = [];
		
		var spr1 = new FlxSprite().loadGraphic('assets/images/menu/screenshots/' + micros[curSelected] + '_1.png');
		spr1.setGraphicSize(Std.int(spr1.width * .4));
		spr1.updateHitbox();
		spr1.y = 40;
		spr1.x = FlxG.width - 540;
		spr1.ID = 1;
		add(spr1);

		var spr2 = new FlxSprite().loadGraphic('assets/images/menu/screenshots/' + micros[curSelected] + '_2.png');
		spr2.setGraphicSize(Std.int(spr2.width * .3));
		spr2.updateHitbox();
		spr2.y = spr1.y + spr1.height + 30;
		spr2.ID = 2;
		add(spr2);
		
		var spr3 = new FlxSprite().loadGraphic('assets/images/menu/screenshots/' + micros[curSelected] + '_3.png');
		spr3.setGraphicSize(Std.int(spr3.width * .2));
		spr3.updateHitbox();
		spr3.y = spr2.y + spr2.height + 30;
		spr3.ID = 3;
		add(spr3);

		Utilities.centerSpriteOnSprite(spr2, spr1, true, false);
		Utilities.centerSpriteOnSprite(spr3, spr1, true, false);

		screenies = [spr1, spr2, spr3];
		
		for(i in screenies){
			var ogx = i.x;
			
			i.x = FlxG.width;
			screentweens.push(FlxTween.tween(i, {x: ogx}, .5 + (0.3 * i.ID), {ease: FlxEase.quartOut}));
		}
	}
	
	function killTweens():Void{
		for(i in screentweens){
			if(i != null && i.active){
				i.cancel();
			}
		}
		
		screentweens = [];
	}
	
	function formList():Void{
		var data = Utilities.dataFromTextFile('assets/data/microgames.txt');

		for (i in 0...data.length)
		{
			var stuff:Array<String> = data[i].split(":");

			micros.push(stuff[0]);
		}
	}
}