package com.sty.iso {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
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
			weaponHeight = weapon.height
			weaponWidth =  weapon.width
			_weaponRect = new Rectangle(0,0,weapon.width , weapon.height);
		}
		
		public function drop():void{
			isDrop = true
		}
		
		public function setAttackState(_attack:int):void{
			attackState = _attack;
			if(attackState == -1){
				_weaponRect = new Rectangle();
				currentWeapon.visible = false
			}else if(attackState == 1){
				currentWeapon.visible = true
				_weaponRect.width = weaponWidth;
				_weaponRect.height = weaponHeight;
				switch(currentDirection)
				{
					case 1:
						_weaponRect.x = x
						_weaponRect.y = z - weaponHeight/2
						break;
					case 2:
						_weaponRect.x = x
						_weaponRect.y = z
						break;
					case 3:
						_weaponRect.x = x - weaponWidth/2
						_weaponRect.y = z
						break;
					case 4:
						_weaponRect.x = x - weaponWidth
						_weaponRect.y = z
						break;
					case 5:
						_weaponRect.x = x - weaponWidth
						_weaponRect.y = z - weaponHeight/2
						break;
					case 6:
						_weaponRect.x = x - weaponWidth
						_weaponRect.y = z - weaponHeight
						break;
					case 7:
						_weaponRect.x = x - weaponWidth/2
						_weaponRect.y = z - weaponHeight
						break;
					case 8:
						_weaponRect.x = x 
						_weaponRect.y = z - weaponHeight
						break;
				}
			}
		}
		
		public function setDirection(dir:int):void{
			currentWeapon.rotation = (dir-1)*45;
			currentDirection = dir
			
		}
		
		
		override public function onRender():void{
			super.onRender();			
		}
	}
}