package playframe.menu.config;

/**
 * the menu where you pick a character to play as
 */
class CharacterSelectState extends FlxSubState 
{	
	/**
	 * the scrolling bg
	 */
	var bg:FlxBackdrop;
		
	/**
	 * the tween that switches the color of the bg
	 */
	var colorTween:ColorTween;

	var namePlate:FlxSprite;
	
	/**
	 * the list of avatars
	 */
	var avatars:Array<String> = [];
	
	/**
	 * the sprites
	 */
	var avatarSprites:FlxTypedGroup<CharacterSelectSprite>;
	
	/**
	 * which option is selected
	 */
	public static var curSelected:Int = 0;
	
	var internalCurSelected:Int = 0;
	
	var abilityText:FlxText;
	
	var canSelect:Bool = false;
	
	override public function create()
	{		 
		super.create();

		MainMenuState.canSelect = false;
		
		var data = Utilities.dataFromTextFile('assets/data/avatars.txt');

		for (i in 0...data.length)
		{
			var stuff:Array<String> = data[i].split(":");

			avatars.push(stuff[0]);
		}
						
		bg = new FlxBackdrop('assets/images/bgtile.png', XY, 0, 0);
		bg.velocity.set(10, 10);
        add(bg);
		
		avatarSprites = new FlxTypedGroup<CharacterSelectSprite>();
		add(avatarSprites);
		
		for(i in 0...avatars.length){
			var portrait = new CharacterSelectSprite(avatars[i]);
			portrait.ID = i;
			avatarSprites.add(portrait);
		}
		
		namePlate = new FlxSprite();
		add(namePlate);
		
		abilityText = new FlxText();
        abilityText.setFormat('assets/fonts/Andy.ttf', 40, 0xFFFFFF, CENTER); 
		abilityText.screenCenter();
		add(abilityText);
		
		changeSelection();
		
		for(i in this.members){
			try {
				Reflect.setProperty(i, 'alpha', 0);
				try {
					FlxTween.tween(i, {alpha: 1}, .5, {ease: FlxEase.quartOut, onComplete: function(F):Void{
						canSelect = true;
					}});	
				} catch(e:Dynamic) {
					trace("Failed to access or tween alpha: " + e);
				}
			} catch (e:Dynamic) {
				trace("Failed to access or tween alpha: " + e);
			}
		}
		
		for(i in avatarSprites.members){
			i.followTarget = false;
			if(i.ID != curSelected){
				i.scale.set(0.3, 0.3);
				i.updateHitbox();	
			}
			
			i.y = FlxG.height - i.height;            

			var ogY = i.y;
				
			i.y = FlxG.height;
			FlxTween.tween(i, {y: ogY}, .5, {ease: FlxEase.quartOut, onComplete: (function(f):Void{
				i.followTarget = true;
			})});
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if(canSelect){
			if(Controls.getControl('LEFT', 'RELEASE')){
				changeSelection(-1);
			}
			
			if(Controls.getControl('RIGHT', 'RELEASE')){
				changeSelection(1);
			}
			
			if(Controls.getControl('ACCEPT', 'RELEASE')){
				select();
			}
		}
		
		internalCurSelected = curSelected;
	}
	
	function select():Void{
		canSelect = false;
		PlayState.curAvatar = avatars[curSelected];
		SaveData.save();
		for(i in this.members){
			try {
				Reflect.setProperty(i, 'alpha', 1);
				try {
					FlxTween.tween(i, {alpha: 0}, .5, {ease: FlxEase.quartOut, onComplete: function(F):Void{
						close();
						MainMenuState.canSelect = true;
					}});	
				} catch(e:Dynamic) {
					trace("Failed to access or tween alpha: " + e);
				}
			} catch (e:Dynamic) {
				trace("Failed to access or tween alpha: " + e);
			}
		}
		
		for(i in avatarSprites.members){
			if(i.ID == curSelected){
				i.targetScaleX = .3;
				i.targetScaleY = 2;
				FlxTween.tween(i, {alpha: 0}, .5, {ease: FlxEase.quartOut});
			} else {
				i.followTarget = false;
				FlxTween.tween(i, {y: FlxG.height}, .5, {ease: FlxEase.quartOut});
			}
		}
	}
	
	function changeSelection(amount:Int = 0):Void{
		curSelected += amount;

		if (curSelected >= avatars.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = avatars.length - 1;
		
		var bullShit:Int = 0;

		avatarSprites.forEachAlive(function(spr:CharacterSelectSprite)
		{
			spr.targetX = bullShit - curSelected;
			bullShit++;

			if (spr.ID != curSelected)
			{
				spr.targetScale = .3;
			}
			else
			{
				spr.targetScale = .5;
			}
		});	

		var data = new AvatarData(avatars[curSelected]);
				
		namePlate.loadGraphic('assets/images/nameplates/' + avatars[curSelected] + '.png');
		namePlate.scale.set(.8, .8);
		namePlate.y = 20;
		namePlate.screenCenter(X);
		namePlate.color = data.color;
		
		abilityText.color = data.color;
		abilityText.text = data.abilityText;
		abilityText.screenCenter();
		abilityText.y -= 100;
		
		changeBgColor(data.color.getDarkened(.6));
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
}