var bg:FlxSprite;
var guy:FlxSprite;

var hand1:FlxSprite;
var hand2:FlxSprite;

var hands:Array<FlxSprite> = [];

var buttons:Array<FlxSprite> = [];
var details:Array<FlxSprite> = [];

var buttonsToPress:Array<Int> = [];

var baseHandX:Array<Float> = [];
var baseHandY:Array<Float> = [];

var targetHandX:Array<Float> = [];
var targetHandY:Array<Float> = [];

var headtween:FlxTween;

var text1:FlxSprite;

var canControl:Bool = false;

var progress:Int = 0;

var failed:Bool = false;

var shakeTween:FlxTween;

var amountofinputs:Int = 4;

function create(){
    PlayState.wonMicrogame = false;

    if(PlayState.harder){
        amountofinputs = 5;    
    }
    
    for(i in 0...amountofinputs){
        buttonsToPress.push(FlxG.random.int(0,3));
    }
    
    bg = new FlxSprite().loadGraphic('assets/images/microgames/repeat/bg.png');
    Utilities.centerSpriteOnPos(bg, frameWidth / 2, frameHeight / 2);
    microgameGroup.add(bg); 
    
    guy = new FlxSprite();
    guy.frames = FlxAtlasFrames.fromSparrow('assets/images/microgames/repeat/guy.png', 'assets/images/microgames/repeat/guy.xml');
    guy.animation.addByPrefix('idle', 'idle', 1);
    guy.animation.addByPrefix('smile', 'smile', 10 * PlayState.additiveSpeed, false);
    guy.animation.addByPrefix('anger', 'anger', 24 * PlayState.additiveSpeed, false);
    guy.animation.play('idle');
    guy.scale.set(.7, .7);
    Utilities.centerSpriteOnPos(guy, frameWidth / 2, frameHeight / 2);
    guy.y -= 130;
    microgameGroup.add(guy);
    
    headtween = FlxTween.tween(guy, {y: guy.y + 20}, 1 * PlayState.subtractiveSpeed, {ease: FlxEase.smootherStepInOut, type: PINGPONG});    
        
    hand1 = new FlxSprite();
    hand1.frames = FlxAtlasFrames.fromSparrow('assets/images/microgames/repeat/hands.png', 'assets/images/microgames/repeat/hands.xml');
    hand1.animation.addByPrefix('point', 'point', 1);
    hand1.animation.addByPrefix('mad', 'mad', 1);
    hand1.animation.addByPrefix('idle', 'idle', 1);
    hand1.animation.addByPrefix('good', 'good', 1);
    hand1.animation.play('idle');
    hand1.flipX = true;
    hand1.scale.set(.7, .7);
    Utilities.centerSpriteOnPos(hand1, frameWidth / 2, frameHeight / 2);
    hand1.x -= 300;
    hand1.y -= 90;
    
    hand2 = new FlxSprite();
    hand2.loadGraphicFromSprite(hand1);
    hand2.flipX = false;
    hand2.scale.set(.7, .7);
    Utilities.centerSpriteOnPos(hand2, frameWidth / 2, frameHeight / 2);
    hand2.x += 300;
    hand2.y -= 90;
    hand2.animation.play('idle');
    
    hands = [hand1, hand2];
    
    baseHandX = [hand1.x, hand2.x];
    baseHandY = [hand1.y, hand2.y];
    
    resetTargets();
    
    hand1.x += 30;
    hand1.y += 30;
    
    hand2.x -= 30;
    hand2.y += 30;
    
    for(i in 0...4){
        var button = new FlxSprite();
        button.frames = FlxAtlasFrames.fromSparrow('assets/images/microgames/repeat/button_' + i + '.png', 'assets/images/microgames/repeat/button_' + i + '.xml');
        button.animation.addByPrefix('idle', 'idle', 1);
        button.animation.addByPrefix('pressed', 'pressed', 30, false);
        button.animation.play('idle');
        Utilities.centerSpriteOnPos(button, frameWidth / 2, frameHeight / 2);
        button.y += 180;
        button.ID = i;
        microgameGroup.add(button);
        
        buttons.push(button);

        var design = new FlxSprite().loadGraphic('assets/images/microgames/repeat/design_' + i + '.png');
        design.ID = i;
        design.setPosition(button.x, button.y);
        design.alpha = .5;
        microgameGroup.add(design);
        
        details.push(design);
    }
    
    microgameGroup.add(hand1);
    microgameGroup.add(hand2);
    
    Utilities.centerGroup(null, buttons, 15, frameWidth / 2);
    Utilities.centerGroup(null, details, 15, frameWidth / 2);
    
    text1 = new FlxSprite().loadGraphic('assets/images/microgames/repeat/text.png');
    Utilities.centerSpriteOnPos(text1, frameWidth / 2, frameHeight / 2);
    text1.visible = false;
    text1.y -= 40;
    microgameGroup.add(text1); 
    
    new FlxTimer().start(.5 * PlayState.subtractiveSpeed, function(tmr:FlxTimer)
    {
        for(i in 0...amountofinputs){
            new FlxTimer().start(((PlayState.harder ? .6 : .7) * i) * PlayState.subtractiveSpeed, function(tmr:FlxTimer)
            {
                cpuPress(buttonsToPress[i]);
                
                if(i == amountofinputs - 1){
                    new FlxTimer().start((.5) * PlayState.subtractiveSpeed, function(tmr:FlxTimer)
                    {
                        startYourTurn();
                    });
                }
            });
        }
    });
}

function startYourTurn():Void{
    text1.visible = true;
    canControl = true;
}

function cpuPress(id:Int):Void{
    var button = buttons[id];
    
    new FlxTimer().start((.2) * PlayState.subtractiveSpeed, function(tmr:FlxTimer)
    {        
        pressButton(button, true);
    });
    
    var handnum = 1;
    
    if(id > 1){
        handnum = 1;
    } else {
        handnum = 0;
    }
    
    targetHandX[handnum] = button.x + button.width / 2 - hand1.width / 2;
    targetHandY[handnum] = 300;
        
    hands[handnum].animation.play('point');

    new FlxTimer().start((.5) * PlayState.subtractiveSpeed, function(tmr:FlxTimer)
    {
        hands[handnum].animation.play('idle');
        
        resetTargets();
    });
}

function pressButton(button:FlxSprite, correct:Bool):Void{
    button.animation.play('pressed', true);  
    playSound('assets/sounds/piano_' + (correct ? button.ID + 1 : 'bad') + '.ogg', 1);
}

function resetTargets():Void{
    targetHandX = [baseHandX[0], baseHandX[1]];
    targetHandY = [baseHandY[0], baseHandY[1]];
}

function update(elapsed:Float){
    if(!failed){
        hand1.x = Utilities.lerpThing(hand1.x, targetHandX[0], elapsed, 5 * PlayState.additiveSpeed);
        hand1.y = Utilities.lerpThing(hand1.y, targetHandY[0], elapsed, 5 * PlayState.additiveSpeed);
        hand2.x = Utilities.lerpThing(hand2.x, targetHandX[1], elapsed, 5 * PlayState.additiveSpeed);
        hand2.y = Utilities.lerpThing(hand2.y, targetHandY[1], elapsed, 5 * PlayState.additiveSpeed);   
    } else {
        hand1.setPosition(baseHandX[0] + FlxG.random.int(-2, 2), baseHandY[0] + FlxG.random.int(-2, 2));
        hand2.setPosition(baseHandX[1] + FlxG.random.int(-2, 2), baseHandY[1] + FlxG.random.int(-2, 2));
    }
    
    if(canControl){
        var inputs = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
        
        for(i in 0...4){
          if(Controls.getControl(inputs[i], 'RELEASE')){
            if(buttonsToPress[progress] == i && !failed){
                pressButton(buttons[i], true);
                progress ++;
                if(progress == amountofinputs){
                    win();
                }
            } else {
                pressButton(buttons[i], false);
                fail();
            }
          }  
        }
    }
}

function win():Void{
    canControl = false;
    PlayState.wonMicrogame = true;
    
    changeText('2');
    
    text1.scale.set(2, .5);
    
    shakeTween = FlxTween.tween(text1.scale, {x: 1, y: 1}, 1 * PlayState.subtractiveSpeed, {ease: FlxEase.quartOut});    

    guy.animation.play('smile');
    
    hand1.animation.play('good');
    hand2.animation.play('good');
}

function fail():Void{
    if(failed) return;
    
    failed = true;
    
    changeText('3');
    
    shaketween = FlxTween.shake(text1, 0.1, 0.2);
    
    guy.animation.play('anger');
    
    hand1.animation.play('mad');
    hand2.animation.play('mad');
}

function changeText(type:String):Void{
    text1.loadGraphic('assets/images/microgames/repeat/text' + type + '.png');
}

function endMicrogame():Void{

}

function destroyMicrogame():Void{
    bg.destroy();
    guy.destroy();
    hand1.destroy();
    hand2.destroy();
    
    for(i in buttons){
        i.destroy();    
    }
    buttons = [];
    
    for(i in details){
        i.destroy();    
    }
    details = [];
    
    cancelGuyTween();
    cancelShakeTween();
    
    text1.destroy();
}

function cancelGuyTween():Void{
    if(headtween != null && headtween.active){
        headtween.cancel();
        headtween.destroy();
        headtween = null;        
    }
}

function cancelShakeTween():Void{
    if(shakeTween != null && shakeTween.active){
        shakeTween.cancel();
        shakeTween.destroy();
        shakeTween = null;        
    }
}