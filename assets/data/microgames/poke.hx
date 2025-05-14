var bg:FlxSprite;
var coma:FlxSprite;
var wither:FlxSprite;
var arrows:FlxSprite;

var pokedLeft:Bool = true;

var pokeCount:Int = 0;
var maxPokeCount:Int = 7;

var gameDone:Bool = false;

var comaSlideTween:FlxTween;

var squishTweens:Array<FlxTween> = [];
var squishing:Bool = false;

function create(){
    PlayState.wonMicrogame = false;

    bg = new FlxSprite().makeGraphic(frameWidth, frameHeight);
    microgameGroup.add(bg);
    
    coma = new FlxSprite();
    coma.frames = FlxAtlasFrames.fromSparrow('assets/images/microgames/poke/pokecoma.png', 'assets/images/microgames/poke/pokecoma.xml');
    coma.animation.addByPrefix('idle', 'idle', 1);
    coma.animation.addByPrefix('pokeleft', 'left', 1);
    coma.animation.addByPrefix('pokeright', 'right', 1);
    coma.animation.addByPrefix('dead', 'dead', 1);
    coma.animation.play('idle');
    Utilities.centerSpriteOnPos(coma, frameWidth / 2, frameHeight / 2);
    microgameGroup.add(coma);
    
    wither = new FlxSprite();
    wither.frames = FlxAtlasFrames.fromSparrow('assets/images/microgames/poke/pokewither.png', 'assets/images/microgames/poke/pokewither.xml');
    wither.animation.addByPrefix('pokeleft', 'pokeleft', 1);
    wither.animation.addByPrefix('pokeright', 'pokeright', 1);
    wither.animation.addByPrefix('win', 'win', 1);
    wither.animation.play('pokeleft');
    Utilities.centerSpriteOnPos(wither, frameWidth / 2, frameHeight / 2);
    microgameGroup.add(wither);
    
    arrows = new FlxSprite();
    arrows.frames = FlxAtlasFrames.fromSparrow('assets/images/microgames/poke/arrows.png', 'assets/images/microgames/poke/arrows.xml');
    arrows.animation.addByPrefix('left', 'left', 1);
    arrows.animation.addByPrefix('right', 'right', 1);
    arrows.animation.play('right');
    microgameGroup.add(arrows);
}

function update(elapsed:Float){
    if(!gameDone){
        Utilities.centerSpriteOnPos(arrows, frameWidth / 2, frameHeight / 2);
        arrows.x += FlxG.random.int(-3, 3);
        arrows.y += FlxG.random.int(-3, 3);
        
        if(pokedLeft){
            if(Controls.getControl('RIGHT', 'RELEASE')){
                pokeRight();
            }
        } else {
            if(Controls.getControl('LEFT', 'RELEASE')){
                pokeLeft();
            }
        }   
    }
    
    if(squishing){
        for(i in [coma, wither]){
            i.updateHitbox();
            Utilities.centerSpriteOnPos(i, frameWidth / 2, frameHeight / 2);
            i.y = frameHeight - i.height;
        }
        coma.x += FlxG.random.int(-3, 3);
    }
}

function pokeRight():Void{
    playSound('assets/sounds/pokeright.ogg', .7);

    arrows.animation.play('left');

    pokeCount ++;
    
    if(pokeCount > maxPokeCount){
        finish();
    } else {
        pokedLeft = false;
        coma.animation.play('pokeright');
        wither.animation.play('pokeright');   
    }
    
    cancelSlideTween();
    
    var ogX = coma.x;
    
    coma.x += 20;
    
    comaSlideTween = FlxTween.tween(coma, {x: ogX}, .7 * PlayState.subtractiveSpeed, {ease: FlxEase.quartOut}); 
}

function cancelSlideTween():Void{
    if(comaSlideTween != null && comaSlideTween.active){
        comaSlideTween.cancel();
        comaSlideTween.destroy();
    }    
    Utilities.centerSpriteOnPos(coma, frameWidth / 2, frameHeight / 2);
}

function pokeLeft():Void{
    playSound('assets/sounds/pokeleft.ogg', .7);

    arrows.animation.play('right');
    
    pokeCount ++;
    
    if(pokeCount > maxPokeCount){
        finish();
    } else {
        pokedLeft = true;
        coma.animation.play('pokeleft');
        wither.animation.play('pokeleft');
    }
}

function finish():Void{
    playSound('assets/sounds/madwhistle.ogg', 0.4);
    playSound('assets/sounds/grr.ogg', 0.25);

    arrows.visible = false;

    gameDone = true;
    
    coma.animation.play('dead');
    wither.animation.play('win');   
    
    cancelSlideTween();
    
    PlayState.wonMicrogame = true;
    
    for(i in [coma, wither]){
        i.scale.set(1.2, .8);
        squishTweens.push(FlxTween.tween(i.scale, {x: 1, y: 1}, 1 * PlayState.subtractiveSpeed, {ease: FlxEase.quartOut})); 
    }
    squishing = true;
}

function endMicrogame():Void{
    gameDone = true;
    cancelSlideTween();
    
    squishing = false;
    for(i in squishTweens){
        if(i != null){
            i.cancel();
            i.destroy();
        }
    }
}

function destroyMicrogame():Void{
    bg.destroy();
    coma.destroy();
    wither.destroy();
    arrows.destroy();
}