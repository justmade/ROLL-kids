package com.sty.controller
{
	import com.sty.iso.Point3D;
	
	import flash.display.PixelSnapping;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class KeyboardController
	{
		private var mStage:Stage;
		private var _x:Number;
		private var _y: Number;
		private var _z: Number;
		private var RL:int;
		private var UD:int;
		private var U:Boolean;
		private var D:Boolean;
		private var L:Boolean;
		private var R:Boolean;
		private var SP:int = 1
		public function KeyboardController(_stage:Stage)
		{
			mStage = _stage;
			mStage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown)
			mStage.addEventListener(KeyboardEvent.KEY_UP , onKeyUp)
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.W:
				{
					U = true
					UD = -1
					break;
				}
				case Keyboard.S:
				{
					D = true
					UD = 1
					break;
				}
				case Keyboard.A:
				{
					L = true
					RL =-1
					break;
				}
				case Keyboard.D:
				{
					RL = 1 
					R = true
					break;
				}
				case Keyboard.SPACE:{
					trace("sp down")
					SP = 3;
					break;
				}
			}
		}
		
		protected function onKeyUp(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.W:
				{
					U = false
					if(D == true){
						UD = 1
					}else{
						UD = 0
					}
					break;
				}
				case Keyboard.S:
				{
					D = false
					if(U){
						UD = -1
					}else{
						UD = 0
					}
					break;
				}
				case Keyboard.A:
				{
					L = false
					if(R){
						RL = 1 
					}else{
						RL = 0
					}
					break;
				}
				case Keyboard.D:
				{
					R = false
					if(L){
						RL = -1
					}else{
						RL = 0
					}
					break;
				}
				case Keyboard.SPACE:
				{
					trace("sp up")
					SP = 1;
					break;
				}
			}
		}
		
		public function getKeyboard():Point3D{
//			return new Point3D(RL,0,UD)
			return transformDir()
		}
		
		private function transformDir():Point3D{
			if(RL == 1){
				_x = 1;
				if(UD == 0){
					_x = 1/Math.SQRT2
					_z = -1/Math.SQRT2;
				}else if(UD == 1){
					_z = 0	
				}else if(UD == -1){
					_x = 0
					_z = -1
				}
			}else if(RL == -1){
				_x = -1;
				if(UD == 0){
					_x = -1/Math.SQRT2
					_z = 1/Math.SQRT2;
				}else if(UD == 1){
					_x = 0
					_z = 1	
				}else if(UD == -1){
					_z = 0
				}
			}else{
				if(UD == 0){
					_x = 0
					_z = 0
				}else if(UD == 1){
					_x = 1
					_z = 1
				}else if(UD == -1){
					_x = -1
					_z = -1
				}
			}
			var p =  new Point3D(_x * SP,0,_z*SP);
			return p
		}
	}
}