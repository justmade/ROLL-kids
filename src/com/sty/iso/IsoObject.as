package com.sty.iso {
	import com.sty.math.Vector2D;
	
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
		protected var _g:Number = 0.1
		protected var jumpAcc:Number = -1.6
		protected var _roadType:String
		protected var _acceleration:Point3D;
		
		public var _type:String = ""
		public var isDrop:Boolean = false;
		public var movePath:Array
		public var _weaponRect:Rectangle;
		
		protected var attackState:int = -1
		protected var weaponWidth:Number = 0;
		protected var weaponHeight:Number = 0;
		protected var currentDirection:int = 1
			
		private var lastGrid:Point = new Point()
		public static const Y_CORRECT:Number=Math.cos(- Math.PI/6)*Math.SQRT2;
		
		public function IsoObject(size:Number) {
			_size=size;
			_position = new Point3D();
			_acceleration = new Point3D();
			_weaponRect = new Rectangle()
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
		
		public function get weapon():Rectangle{
			return _weaponRect
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
		
		public function jump():void{
//			jumpAcc = -0.3 * Math.random() - 1.3
			_acceleration.y += jumpAcc
		}
		
		/**
		 *如果掉出屏幕了，再放回屏幕 
		 * 
		 */		
		private function dropOutScreen():void{
			if(this.position.y >= 500 && isDrop){
				this.position.y = -500
				this.position.x = 0
				this.position.z = 0
			}
		}
		
		private function searchPlayer():void{
			if(movePath && movePath.length>0){
				var closePoint:Point = movePath[movePath.length-1];
				var v:Vector2D = new Vector2D(closePoint.x - this.x , closePoint.y - this.z)
				if(v.length <= 1){
					movePath.pop()
				}
				var vel:Vector2D = v.normalize().multiply(1)	
				this.vx = vel.x;
				this.vz = vel.y;
				if(movePath.length == 0){
					this.vx = 0;
					this.vz = 0;
				}
			}
		}
		
		public function gridChange(_worldSize:int):Boolean{
			var cx:int = Math.floor(this.x/_worldSize)
			var cy:int = Math.floor(this.z/_worldSize)
			if(!lastGrid.equals(new Point(cx,cy))){
				lastGrid = new Point(cx,cy)
				return false
			}
			return true
		}
		
		public function onRender():void{
			if(this.y >= 0 && isDrop == false){
				this.y = 0
				_acceleration.y -= _g
//				jump()
			}
			searchPlayer()
			dropOutScreen()			
			_acceleration.y += _g
			this.vx += _acceleration.x
			this.vy += _acceleration.y
			this.vz += _acceleration.z
			this.y += this.vy;
			this.x += this.vx;
			this.z += this.vz;
			_acceleration.x = 0
			_acceleration.y = 0
			_acceleration.z = 0 
				
		}
		
		public function attacked(_x:Number,_y:Number):void{
			if(_x!=0)_acceleration.x = 13 * _x / Math.abs(_x)
			if(_y!=0)_acceleration.z = 13 * _y / Math.abs(_y)
		}
	}
}