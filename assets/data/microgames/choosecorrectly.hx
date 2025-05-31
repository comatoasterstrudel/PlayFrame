var bg:FlxSprite;
var sign1:FlxSprite;
var sign2:FlxSprite;
var guy:FlxSprite;
var arrows:FlxSprite;

var speed:Float = 200;

var won:Bool = false;

var microgameOver:Bool = false;

var left:Bool = false;

var mysteryleft:FlxSprite;
var mysteryright:FlxSprite;

function create(){
    PlayState.wonMicrogame = false;

    left = FlxG.random.bool(50); //if this is true, the winning is on the left.
    
    bg = new FlxSprite().loadGraphic('assets/images/microgames/choosecorrectly/bg.png');
    bg.scale.set(2, 2);
    bg.antialiasing = false;
    Utilities.centerSpriteOnPos(bg, frameWidth / 2, frameHeight / 2);
    microgameGroup.add(bg);
    
    var prefix:String = '';
    
    if(PlayState.harder) prefix = 'mystery_';
    
    sign1 = new FlxSprite().loadGraphic('assets/images/microgames/choosecorrectly/' + prefix + (left ? 'goodsign' : 'badsign') + '.png');
    sign1.scale.set(2, 2);
    sign1.antialiasing = false;
    Utilities.centerSpriteOnPos(sign1, frameWidth / 2, frameHeight / 2);
    microgameGroup.add(sign1);

    sign2 = new FlxSprite().loadGraphic('assets/images/microgames/choosecorrectly/' + prefix + (left ? 'badsign' : 'goodsign') + '.png');
    sign2.scale.set(2, 2);
    sign2.flipX = true;
    sign2.antialiasing = false;
    Utilities.centerSpriteOnPos(sign2, frameWidth / 2, frameHeight / 2);
    microgameGroup.add(sign2);
    
    guy = new FlxSprite();
    guy.frames = FlxAtlasFrames.fromSparrow('assets/images/microgames/choosecorrectly/guy.png', 'assets/images/microgames/choosecorrectly/guy.xml');
    guy.animation.addByPrefix('idle', 'idle', 10 * PlayState.additiveSpeed);
    guy.animation.addByPrefix('walk', 'walk', 10 * PlayState.additiveSpeed);
    guy.animation.addByPrefix('pop', 'pop', 10 * PlayState.additiveSpeed, false);
    guy.animation.addByPrefix('polploop', 'polploop', 10 * PlayState.additiveSpeed);
    guy.animation.addByPrefix('happy', 'happy', 10 * PlayState.additiveSpeed);
    guy.scale.set(2,2);
    guy.updateHitbox();
    Utilities.centerSpriteOnPos(guy, frameWidth / 2, frameHeight / 2);
    guy.y += 30;
    guy.antialiasing = false;
    microgameGroup.add(guy);
    
    arrows = new FlxSprite();
    arrows.frames = FlxAtlasFrames.fromSparrow('assets/images/microgames/choosecorrectly/arrows.png', 'assets/images/microgames/choosecorrectly/arrows.xml');
    arrows.animation.addByPrefix('flash', 'flash', 3);
    arrows.animation.play('flash');
    arrows.scale.set(2,2);
    arrows.updateHitbox();
    Utilities.centerSpriteOnPos(arrows, frameWidth / 2, frameHeight / 2);
    microgameGroup.add(arrows);
    
    if(PlayState.harder){
        mysteryleft = new FlxSprite().loadGraphic('assets/images/microgames/choosecorrectly/mystery.png');
        mysteryleft.scale.set(2,2);
        mysteryleft.updateHitbox();
        Utilities.centerSpriteOnPos(mysteryleft, frameWidth / 2, frameHeight / 2);
        mysteryleft.x = 0;
        mysteryleft.antialiasing = false;
        microgameGroup.add(mysteryleft);

        mysteryright = new FlxSprite().loadGraphic('assets/images/microgames/choosecorrectly/mystery.png');
        mysteryright.scale.set(2,2);
        mysteryright.updateHitbox();
        Utilities.centerSpriteOnPos(mysteryright, frameWidth / 2, frameHeight / 2);
        mysteryright.x = 640;
        mysteryright.antialiasing = false;
        microgameGroup.add(mysteryright);
    }
}

function update(elapsed):Void{
    guy.velocity.set(0,0);
    
    if(!microgameOver){
        if(Controls.getControl('RIGHT', 'HOLD')){
            guy.velocity.x = (speed * PlayState.additiveSpeed);
        }
        
        if(Controls.getControl('LEFT', 'HOLD')){
            guy.velocity.x = (-speed * PlayState.additiveSpeed);
        }
        
        if(guy.velocity.x == 0) guy.animation.play('idle');
        
        if(guy.velocity.x < 0){
            arrows.visible = false;
            guy.animation.play('walk', false);  
            guy.flipX = false;
        } else if(guy.velocity.x > 0){
            arrows.visible = false;
            guy.animation.play('walk', false);  
            guy.flipX = true;
        }
        
        if(!won){
            if(guy.x + guy.width / 2 <= ((frameWidth / 2) - 175)){ //on the left
                if(left) win(); else lose();
            } else if(guy.x + guy.width / 2 >= ((frameWidth / 2) + 175)){
                if(!left) win(); else lose();
            }
        }           
    }
}

function win():Void{
    PlayState.wonMicrogame = true;
    
    microgameOver = true;
    
    guy.animation.play('happy', false);  
    
    playSound('assets/sounds/yay.ogg', 1);
}

function lose():Void{
    PlayState.wonMicrogame = false;
    
    microgameOver = true;
    
    guy.animation.play('pop', false);  
    guy.animation.finishCallback = function(name:String):Void{
        guy.animation.play('polploop', false);  
    }
    playSound('assets/sounds/headpop.ogg', 1);
}

function endMicrogame():Void{
    microgameOver = true;
}

function destroyMicrogame():Void{
    bg.destroy();
    sign1.destroy();
    sign2.destroy();
    guy.destroy();
    arrows.destroy();
    
    if(PlayState.harder){
        mysteryleft.destroy();
        mysteryright.destroy();
    }
}
