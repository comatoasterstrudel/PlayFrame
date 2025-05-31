package playframe.helpers;

class LoadingState extends FlxState
{
    override function create():Void{
        super.create();
        
        DiscordClient.changePresence('Loading', null);

        trace('loading');
        
        for (i in Utilities.findFilesInPath('assets', ['.ogg'], true, true))
        {
           FlxG.sound.cache(i);
           trace('Cached Audio: $i');
        }	
            
        for (i in Utilities.findFilesInPath('assets', ['.png'], true, true))
        {
            var graphic:FlxGraphic = FlxGraphic.fromAssetKey(i, false, null, true);
            if (graphic == null)
            {
                FlxG.log.warn('Texture is Null: ' + i);
            }
            else
            {
                trace('Cached Texture: ' + i);

                graphic.persist = true;
            }
        }	

		#if forceMicrogame 
		addChild(new FlxGame(0, 0, PlayState));
		FlxG.mouse.visible = false;
		
		return;
		#end
        
        FlxG.switchState(new MainMenuState());
    }
}