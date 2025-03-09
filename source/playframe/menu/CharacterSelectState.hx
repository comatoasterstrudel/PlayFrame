package playframe.menu;

/**
 * the menu where you pick a character to play as
 */
class CharacterSelectState extends FlxState 
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
	
	override public function create()
	{		 
		super.create();
	
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
		
		changeSelection();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if(Controls.getControl('LEFT', 'RELEASE')){
			changeSelection(-1);
		}
		
		if(Controls.getControl('RIGHT', 'RELEASE')){
			changeSelection(1);
		}
		
		if(Controls.getControl('ACCEPT', 'RELEASE')){
			PlayState.curAvatar = avatars[curSelected];
			FlxG.switchState(new PlayState());
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