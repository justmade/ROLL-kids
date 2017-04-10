package com.sty.iso {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 *有颜色的立方体 
	 * @author dell
	 * 
	 */
	public class DrawnIsoBox extends DrawnIsoTile {
		
		[Embed(source="../../../close-weapon.png")]
		private var Close_Weapon:Class
		
		private var dropTimes:int;
		
		private var currentWeapon:Sprite = new Sprite();
		
		public function DrawnIsoBox(size:Number, color:uint, height:Number , alpha:Number = 1 , type:String="") {
			
			super(size, color, height,alpha);
			_type = type
			addCloseWeapon()
		}
		
		override protected function draw():void {
			graphics.clear();
			
			//提取r,g,b三色分量
			var red:int=_color>>16;
			var green:int=_color>>8&0xff;
			var blue:int=_color&0xff;
			
			//假如光源在右上方（所以左侧最暗，顶上最亮，右侧在二者之间）
			var leftShadow:uint = (red * .5) << 16 |(green * .5) << 8 |(blue * .5);
			var rightShadow:uint = (red * .75) << 16 |(green * .75) << 8 | (blue * .75);
			var h:Number=_height*Y_CORRECT;
			
			//顶部
			graphics.beginFill(_color,_alpha);
			graphics.lineStyle(0, 0, .5);
			graphics.moveTo(-_size, -h);
			graphics.lineTo(0, -_size * .5 - h);
			graphics.lineTo(_size, -h);
			graphics.lineTo(0, _size * .5 - h);
			graphics.lineTo(-_size, -h);
			graphics.endFill();
			
			//左侧
			graphics.beginFill(leftShadow,_alpha);
			graphics.lineStyle(0, 0, .5);
			graphics.moveTo(-_size, -h);
			graphics.lineTo(0, _size * .5 - h);
			graphics.lineTo(0, _size * .5);
			graphics.lineTo(-_size, 0);
			graphics.lineTo(-_size, -h);
			graphics.endFill();
			
			//右侧
			graphics.beginFill(rightShadow,_alpha);
			graphics.lineStyle(0, 0, .5);
			graphics.moveTo(_size, -h);
			graphics.lineTo(0, _size * .5 - h);
			graphics.lineTo(0, _size * .5);
			graphics.lineTo(_size, 0);
			graphics.lineTo(_size, -h);
			graphics.endFill();
		}
		
		public function addCloseWeapon():void
		{
			var weapon:DisplayObject = new Close_Weapon() as DisplayObject
			currentWeapon.addChild(weapon)
			weapon.x = 0;
			weapon.y = -weapon.height/2;
			this.addChild(currentWeapon)
			setDirection(1)
		}
		
		public function drop():void{
			isDrop = true
		}
		
		public function setDirection(dir:int):void{
			currentWeapon.rotation = (dir-1)*45;
		}
		
		
		override public function onRender():void{
			super.onRender();			
		}
	}
}