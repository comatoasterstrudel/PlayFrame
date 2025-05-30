package playframe.game;

import playframe.json.MicrogameData;

/**
 * the games namesake. this contains all of the gameplay for each player!!
 */
class PlayFrame extends FlxTypedGroup<FlxTypedGroup<FlxSprite>>
{
    /**
     * the camera the frame is displayed on!!
     */
    public var frameCamera:FlxCamera;
    
    /**
     * the camera the frame is displayed on!!
     */
     var topCamera:FlxCamera;
     
    /**
     * how wide the frames should be
     */
    public static var frameWidth:Int = 900;
    
    /**
     * how wide the gaps between the top anbd bottom should be
     */
    public static final frameMargin:Int = 20;
    
    var frameHeight:Int = 0;
    
    var baseSceneGroup:FlxTypedGroup<FlxSprite>;
    
    var microgameGroup:FlxTypedGroup<FlxSprite>;
    
    var transitionGroup:FlxTypedGroup<FlxSprite>;
    
    var groupList:Array<FlxTypedGroup<FlxSprite>> = [];
    
    var baseBackground:FlxBackdrop;
    
    var baseCharacter:CharacterSprite;
    
    var microgameScript:HaxeScript;
    
    public function new(positionOffset:Float){
        super();
        
        frameCamera = new FlxCamera((FlxG.width / 2 - frameWidth / 2) + positionOffset, PlayState.scoreBgHeight + frameMargin, frameWidth, (FlxG.height - PlayState.scoreBgHeight) - (frameMargin * 2));
		frameCamera.bgColor = FlxColor.BLACK;
		FlxG.cameras.add(frameCamera, false);
        
        frameHeight = frameCamera.height;
        
        frameWidth += 1;
        frameHeight += 1;
        
        topCamera = new FlxCamera((FlxG.width / 2 - frameWidth / 2) + positionOffset, PlayState.scoreBgHeight + frameMargin, frameWidth, (FlxG.height - PlayState.scoreBgHeight) - (frameMargin * 2));
		topCamera.bgColor = FlxColor.TRANSPARENT;
		FlxG.cameras.add(topCamera, false);
        
        baseSceneGroup = new FlxTypedGroup<FlxSprite>();        
        microgameGroup = new FlxTypedGroup<FlxSprite>();        
        transitionGroup = new FlxTypedGroup<FlxSprite>();        
        groupList = [baseSceneGroup, microgameGroup, transitionGroup];
        
        reOrderGroups([baseSceneGroup, microgameGroup, transitionGroup]);
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        FlxG.worldBounds.set(frameCamera.scroll.x, frameCamera.scroll.y, FlxG.width, FlxG.height); //FUCK EVERYTHING

        if(microgameScript != null) {
            microgameScript.executeFunc('update', [elapsed]);
        }        
    }
    
    public function updateSpeed():Void{
        if(baseBackground != null){
            baseBackground.velocity.set(20 * PlayState.additiveSpeed, 20 * PlayState.additiveSpeed);            
        }
        if(baseCharacter != null){
            baseCharacter.updateFps();
        }
    }
    
    override function add(basic:FlxTypedGroup<FlxSprite>):FlxTypedGroup<FlxSprite>{
        basic.camera = frameCamera;
        super.add(basic);
        return basic;
    }
    
    var characterSprite:FlxSprite;
    
    function reOrderGroups(groups:Array<FlxTypedGroup<FlxSprite>>):Void{
        for(i in groupList){
            remove(i);
        }
        
        for(i in groups){
            add(i);
        }
        
        microgameGroup.camera = frameCamera;
        baseSceneGroup.camera = topCamera;
        transitionGroup.camera = topCamera;
    }
    
    var soundGroup:Array<FlxSound> = [];
    
    public function playSound(path:String, volume:Float):FlxSound{
		var sound:FlxSound = new FlxSound();
		sound.loadEmbedded(path, false);
		sound.volume = volume;
        sound.pitch = PlayState.additiveSpeed;
		sound.play();
		FlxG.sound.list.add(sound);
		soundGroup.push(sound);
        return sound;
	}
    
    public function addIntroScene():Void{
        reOrderGroups([baseSceneGroup, microgameGroup, transitionGroup]);
                
        addBaseObjects();
        
        baseCharacter.playAnim('intro');
    }
    
    public function addTutorialScene():Void{
        reOrderGroups([baseSceneGroup, microgameGroup, transitionGroup]);
                
        addTutorialObjects();
        
        baseCharacter.playAnim('intro');
    }
    
    public function addTutorialObjects():Void{
        baseBackground = new FlxBackdrop('assets/images/framebg/tut.png', XY, 0, 0);
        baseSceneGroup.add(baseBackground);
        
        baseCharacter = new CharacterSprite('tut');
        Utilities.centerSpriteOnPos(baseCharacter, frameWidth / 2);
        baseCharacter.y = frameHeight;
        baseSceneGroup.add(baseCharacter);
        FlxTween.tween(baseCharacter, {y: frameHeight - baseCharacter.height}, 1 * PlayState.subtractiveSpeed, {ease: FlxEase.quartOut});
        
        updateSpeed();
    }
    
    function addBaseObjects():Void{
        baseBackground = new FlxBackdrop('assets/images/framebg/' + PlayState.curAvatar + '.png', XY, 0, 0);
        baseSceneGroup.add(baseBackground);
        
        baseCharacter = new CharacterSprite(PlayState.curAvatar);
        Utilities.centerSpriteOnPos(baseCharacter, frameWidth / 2);
        baseCharacter.y = frameHeight;
        baseSceneGroup.add(baseCharacter);
        FlxTween.tween(baseCharacter, {y: frameHeight - baseCharacter.height}, 1 * PlayState.subtractiveSpeed, {ease: FlxEase.quartOut});
        
        updateSpeed();
    }
    
    public function startMicroGame(name:String):Void{
        frameCamera.follow(null);
        frameCamera.scroll.set(0,0);
        
        reOrderGroups([microgameGroup, baseSceneGroup, transitionGroup]);
        
        var data = new MicrogameData(name);
        
        var transprite = new FlxSprite().makeGraphic(frameWidth + 2, frameHeight, data.color.getDarkened(.7));
        transprite.x = -transprite.width;
        transprite.alpha = 0;
        transitionGroup.add(transprite);
        
        var text = new FlxText();
        text.setFormat('assets/fonts/Andy.ttf', 70, data.color.getLightened(.2), CENTER, FlxTextBorderStyle.SHADOW, data.color.getDarkened(.2));
		text.text = data.text;
		Utilities.centerSpriteOnPos(text, frameWidth / 2, frameHeight / 2);
		transitionGroup.add(text);
        
        text.y += frameHeight;
        FlxTween.tween(text, {y: text.y - frameHeight}, 1 * PlayState.subtractiveSpeed, {ease: FlxEase.backOut});

        FlxTween.tween(transprite, {alpha: 1}, 1 * PlayState.subtractiveSpeed, {ease: FlxEase.quartOut});
        FlxTween.tween(transprite, {x: -1}, 1 * PlayState.subtractiveSpeed, {ease: FlxEase.quartOut});
        
        new FlxTimer().start(2 * PlayState.subtractiveSpeed, function(tmr:FlxTimer)
        {
            destroyThings();
            
            initMicroGame(); 
            
            FlxTween.tween(text, {y: text.y - frameHeight}, .7 * PlayState.subtractiveSpeed, {ease: FlxEase.backIn});
        
            FlxTween.tween(transprite, {alpha: 0}, 1 * PlayState.subtractiveSpeed, {ease: FlxEase.quartOut});
            FlxTween.tween(transprite, {x: transprite.width}, 1 * PlayState.subtractiveSpeed, {ease: FlxEase.quartOut});

            new FlxTimer().start(1 * PlayState.subtractiveSpeed, function(tmr:FlxTimer)
            {
                transprite.destroy();
                text.destroy();
            });
        });
    }
    
    public function destroyThings():Void{
        baseCharacter.destroy();
        baseBackground.destroy();
        baseCharacter = null;
        baseBackground = null;
    }
    
    function initMicroGame():Void{
        microgameScript = HaxeScript.create('assets/data/microgames/' + PlayState.curMicrogame + '.hx');
		microgameScript.loadFile('assets/data/microgames/' + PlayState.curMicrogame + '.hx');

		ScriptSupport.setScriptDefaultVars(microgameScript, '', '');
			
        microgameScript.setVariable("microgameGroup", microgameGroup);

        microgameScript.setVariable("frameWidth", frameWidth);
        microgameScript.setVariable("frameHeight", frameHeight);
        microgameScript.setVariable("frameCamera", frameCamera);

        microgameScript.setVariable("playSound", playSound);

        microgameScript.executeFunc("create");
    }
    
    public function endMicroGame():Void{
        microgameScript.executeFunc("endMicrogame");
        
        for(i in soundGroup){
            if(i != null){
                if(i.playing) i.stop();
                i.destroy();
            }    
        }
        
        soundGroup = [];
        
        if(PlayState.inTutorial){
            addTutorialObjects();
        } else addBaseObjects();
                
        if(!PlayState.wonMicrogame){
            baseCharacter.playAnim('lose');
        } else {
            baseCharacter.playAnim('win');
        }
        
        if(!PlayState.gameOver){
            var speedingUp = PlayState.checkSpeedUp();
        
            new FlxTimer().start(2 * PlayState.subtractiveSpeed, function(tmr:FlxTimer)
            {
                if(speedingUp){
                    baseCharacter.playAnim('scared', true);
                    
                    new FlxTimer().start(4 * PlayState.subtractiveSpeed, function(tmr:FlxTimer)
                    {
                        baseCharacter.playAnim('normal', true);
                    });
                } else {
                    baseCharacter.playAnim('normal', true);                
                }
            });   
        }
                
        baseBackground.alpha = 0;
        
        FlxTween.tween(baseBackground, {alpha: 1}, 1 * PlayState.subtractiveSpeed, {ease: FlxEase.quartOut});
 
        new FlxTimer().start(1 * PlayState.subtractiveSpeed, function(tmr:FlxTimer)
        {
            microgameScript.executeFunc("destroyMicrogame");
            
            microgameScript.destroy();
            microgameScript = null;
            
            frameCamera.scroll.set(0,0);
            
            trace('Destroyed microgame!!! ' + PlayState.curMicrogame);
        });
    }
    
    public function die():Void{
        if(PlayState.curAvatar == 'illbert'){
            new FlxTimer().start(2 * PlayState.subtractiveSpeed, function(tmr:FlxTimer)
            {
                FlxG.sound.play('assets/sounds/illberthetsshot.ogg', .6);

                baseCharacter.animation.addByPrefix('die', 'die', 20, false);
                baseCharacter.animation.play('die');
            });
        } 
    }
} 