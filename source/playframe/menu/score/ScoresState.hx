package playframe.menu.score;

class ScoresState extends CharacterSelectState
{
	override function select():Void{
		return; // no selecting you stupid mother fucker
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if(canSelect){
			if(Controls.getControl('BACK', 'RELEASE')){
				canSelect = false;
				
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
				
				for(i in avatarSprites.members){
					i.followTarget = false;
						FlxTween.tween(i, {y: FlxG.height}, .5, {ease: FlxEase.quartOut});
				}
			}
		}
		
		for(i in avatarSprites.members){
			i.color = FlxColor.WHITE;
		}
		
		bg.color = FlxColor.GRAY;
		
		abilityText.color = FlxColor.WHITE;
		
		namePlate.color = FlxColor.WHITE;
		
		abilityText.text = 'High-Score: ' + SaveData.highscores.get(avatars[internalCurSelected]);
		abilityText.screenCenter(X);		
	}
}