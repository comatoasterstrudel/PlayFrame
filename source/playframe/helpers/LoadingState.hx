package playframe.helpers;

class LoadingState extends FlxState
{
    override function create():Void{
        super.create();
        
        FlxG.mouse.visible = false;
        
        SaveData.init();
		SaveData.load();
        
        DiscordClient.changePresence('Loading', null);

        var loader = new FlxSprite().loadGraphic('assets/images/load/' + (PlayState.curAvatar == 'illbert' ? 'loadill' : 'load') + '.png');
        loader.screenCenter();
        add(loader);
        
        var text = new FlxSprite().loadGraphic('assets/images/load/text.png');
        text.screenCenter();
        add(text);
        
        loader.y = -loader.height;
        text.y = FlxG.height;

        FlxTween.tween(text, {y: 0}, 1, {ease: FlxEase.bounceOut});

        FlxTween.tween(loader, {y: 0}, 1, {ease: FlxEase.bounceOut, onComplete: function(f):Void{
            new FlxTimer().start(.2, function(tmr:FlxTimer)
			{                                       
                trace('loading');
                    
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
                
                FlxTween.tween(text, {y: -text.height}, 1, {ease: FlxEase.bounceOut});

                FlxTween.tween(loader, {y: FlxG.height}, 1, {ease: FlxEase.bounceIn, onComplete: function(f):Void{
                    #if forceMicrogame 
                    FlxG.switchState(new PlayState());    
                    
                    return;
                    #end
                    
                    FlxG.switchState(new MainMenuState());    
                }});
            });
        }});
    }
}