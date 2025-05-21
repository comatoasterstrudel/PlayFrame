package playframe.menu.score;

class ScoresState extends CharacterSelectState
{
	override function formList():Void{
		super.formList();
		if(!SaveData.checkIllbertUnlocked()){
			avatars.remove('illbert');
		}
	}
	
	override function select():Void{
		return; // no selecting you stupid mother fucker
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
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