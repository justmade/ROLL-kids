package com.sty.iso
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import mx.core.ButtonAsset;
	
	public class StgObject extends Sprite
	{
		
		protected var size:Number;
		protected var _position:Point;
		public function StgObject(_size:Number)
		{
			this.size = _size;
			this._position = new Point();
//			updateScreenPosition()
		}
		
		//更新屏幕坐标位置
		protected function updateScreenPosition():void {
			var screenPos:Point=IsoUtils.screenToStg(_position);
			trace(screenPos)
			super.x=screenPos.x;
			super.y=screenPos.y;
		}
		
		override public function set x(value:Number):void {
			_position.x=value;
			updateScreenPosition();
		}
		
		override public function get x():Number {
			return _position.x;
		}
		
		override public function set y(value:Number):void {
			_position.y=value;
			updateScreenPosition();
		}
		override public function get y():Number {
			return _position.y;
		}
		
		
		//position的属性封装
		public function set position(value:Point):void {
			_position=value;
			updateScreenPosition();
		}
		public function get position():Point {
			return _position;
		}
		
		
	}
	
}