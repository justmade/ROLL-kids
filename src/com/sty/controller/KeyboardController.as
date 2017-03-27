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
		private var _x:int;
		private var _y:int;
		private var _z:int;
		private var RL:int;
		private var UD:int;
		private var U:Boolean;
		private var D:Boolean;
		private var L:Boolean;
		private var R:Boolean;
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
				case Keyboard.UP:
				{
					U = true
					UD = -1
					break;
				}
				case Keyboard.DOWN:
				{
					D = true
					UD = 1
					break;
				}
				case Keyboard.LEFT:
				{
					L = true
					RL =-1
					break;
				}
				case Keyboard.RIGHT:
				{
					RL = 1 
					R = true
					break;
				}
			}
		}
		
		protected function onKeyUp(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.UP:
				{
					U = false
					if(D == true){
						UD = 1
					}else{
						UD = 0
					}
					break;
				}
				case Keyboard.DOWN:
				{
					D = false
					if(U){
						UD = -1
					}else{
						UD = 0
					}
					break;
				}
				case Keyboard.LEFT:
				{
					L = false
					if(R){
						RL = 1 
					}else{
						RL = 0
					}
					break;
				}
				case Keyboard.RIGHT:
				{
					R = false
					if(L){
						RL = -1
					}else{
						RL = 0
					}
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
					_z = -1;
				}else if(UD == 1){
					_z = 0	
				}else if(UD == -1){
					_x = 0
					_z = -1
				}
			}else if(RL == -1){
				_x = -1;
				if(UD == 0){
					_z = 1;
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
			return new Point3D(_x,0,_z)
		}
	}
}