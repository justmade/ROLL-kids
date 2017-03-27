package com.sty.iso {
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class IsoObject extends Sprite {
		
		protected var _position:Point3D;
		protected var _size:Number;
		protected var _walkable:Boolean=false;
		protected var _vx:Number = 0;
		protected var _vy:Number = 0;
		protected var _vz:Number = 0;
		protected var _roadType:String
		
		public static const Y_CORRECT:Number=Math.cos(- Math.PI/6)*Math.SQRT2;
		
		public function IsoObject(size:Number) {
			_size=size;
			_position = new Point3D();
			updateScreenPosition();
		}
		
		//更新屏幕坐标位置
		protected function updateScreenPosition():void {
			var screenPos:Point=IsoUtils.isoToScreen(_position);
			super.x=screenPos.x;
			super.y=screenPos.y;
		}
		
		override public function toString():String {
			return "[IsoObject (x:" + _position.x + ", y:" + _position.y+ ", z:" + _position.z + ")]";
		}
		
		//设置等角空间3D坐标点的x,y,z值
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
		
		override public function set z(value:Number):void {
			_position.z=value;
			updateScreenPosition();
		}
		
		override public function get z():Number {
			return _position.z;
		}
		
		//_position的属性封装
		public function set position(value:Point3D):void {
			_position=value;
			updateScreenPosition();
		}
		public function get position():Point3D {
			return _position;
		}
		
		//深度排序时会用到
		public function get depth():Number {
			return (_position.x + _position.z) * .866 - _position.y * .707;
		}
		

		public function set walkable(value:Boolean):void {
			_walkable=value;
		}
		public function get walkable():Boolean {
			return _walkable;
		}
		
		public function get size():Number {
			return _size;
		}
		
		public function get rect():Rectangle {
			return new Rectangle(x - size / 2, z - size / 2, size, size);
		}
		public function set vx(value:Number):void
		{
			_vx = value;
		}
		public function get vx():Number
		{
			return _vx;
		}
		
		public function set vy(value:Number):void
		{
			_vy = value;
		}
		public function get vy():Number
		{
			return _vy;
		}
		
		public function set vz(value:Number):void
		{
			_vz = value;
		}
		public function get vz():Number
		{
			return _vz;
		}
		
		public function get roadType():String
		{
			return _roadType;
		}
		
		//类型
		public function set roadType(value:String):void
		{
			_roadType = value;
		}
	}
}