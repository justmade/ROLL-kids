package com.sty.iso {
	
	public class Point3D {
		
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		public function Point3D(x:Number=0,y:Number=0,z:Number=0) {
			this.x=x;
			this.y=y;
			this.z=z;
		}
		
		//判断二个Point3D是否相等
		public function equal(p:Point3D):Boolean{
			return this.x==p.x&&this.y==p.y&&this.z==p.z;
		}
		
		public function toString():String{
			return String(this.x) + ","+ String(this.y) + ","+ String(this.z)
		}
	}
}