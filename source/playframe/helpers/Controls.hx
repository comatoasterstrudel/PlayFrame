package playframe.helpers;

/**
 * class to handle control inputs
 */
class Controls {
    public static var controlsList:Array<String> = ['ACCEPT', 'BACK', 'LEFT', 'RIGHT', 'UP', 'DOWN'];
    
    public static var keyboardControls:Map<String, Array<FlxKey>> = [
        'ACCEPT' => [ENTER, Z, SPACE],
        'BACK' => [BACKSPACE, X, ESCAPE],
        'LEFT' => [LEFT, A],
        'RIGHT' => [RIGHT, D],
        'UP' => [UP, W],
        'DOWN' => [DOWN, S],
    ];
    
    public static var gamepadControls:Map<String, Array<FlxGamepadInputID>> = [
        'ACCEPT' => [A],
        'BACK' => [B],
        'LEFT' => [DPAD_LEFT, LEFT_STICK_DIGITAL_LEFT],
        'RIGHT' => [DPAD_RIGHT, LEFT_STICK_DIGITAL_RIGHT],
        'UP' => [DPAD_UP, LEFT_STICK_DIGITAL_UP],
        'DOWN' => [DPAD_DOWN, LEFT_STICK_DIGITAL_DOWN],
    ];
    
    /**
     * call this to see if a control is being pressed
     * @param name which control
     * @param type HOLD / RELEASE
     */
    public static function getControl(name:String, type:String):Bool{
        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

        switch(type)
        {
                case 'HOLD':
                    for(control in keyboardControls.get(name)){
                        if(FlxG.keys.anyPressed([control])) return true;
                    }    
                    
                    if(gamepad != null){
                        for(control in gamepadControls.get(name)){
                            if(gamepad.anyPressed([control])) return true;
                        }   
                    }
                case 'RELEASE':
                    for(control in keyboardControls.get(name)){
                        if(FlxG.keys.anyJustPressed([control])) return true;
                    }   
                    
                    if(gamepad != null){
                        for(control in gamepadControls.get(name)){
                            if(gamepad.anyJustPressed([control])) return true;
                        }   
                    }
        }
        
        return false;
    }
}
