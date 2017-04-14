package com.sty.iso
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import data.ElementType;

	public class IsoWorld extends Sprite
	{
		private var _floor:Sprite;
		private var _objects:Array;
		private var _floors:Array;
		private var _world:Sprite;
		private var _cols:uint=10;
		private var _rows:uint=10;
		private var _cellSize:uint=50;
		private var _deleteCell:Boolean ;


		public function IsoWorld(cols:uint=10,rows:uint=10,cellSize:uint=20)
		{
			this._cols = cols;
			this._rows = rows;
			this._cellSize = cellSize;

			_floor = new Sprite();
			addChild(_floor);
			_world = new Sprite();
			addChild(_world);
			_objects = new Array();
			_floors = new Array();
		}

		public function set cellSize(v:uint):void{
			this._cellSize = v;
		}

		public function get cellSize():uint{
			return this._cellSize;
		}

		public function set rows(v:uint):void{
			this._rows = v;
		}

		public function get rows():uint{
			return this._rows;
		}

		public function set cols(v:uint):void{
			this._cols = v;
		}

		public function get cols():uint{
			return this._cols;
		}

		public function addChildToWorld(child:IsoObject):void
		{
//			//检测box的位置是否挂出去了+重复创建检测
//			if(_deleteCell){
//				deletePos(child.position);
//				return ;
//			}

			if (child.position.x<0 || child.position.x>(_cols-1)*_cellSize ||
				child.position.z<0 || child.position.z>(_rows-1)*_cellSize){
				return;

			}else{
				_world.addChild(child);
				_objects.push(child);
				sort();
			}


		}

		public function addChildToFloor(child:IsoObject):void
		{
			_floors.push(child);
			_floor.addChild(child);
		}

		public function sort():void
		{
			_objects.sortOn("depth", Array.NUMERIC);
			for(var i:int = 0; i < _objects.length; i++)
			{
				_world.setChildIndex(_objects[i], i);
			}
		}

		private function deletePos(p:Point3D):void{
			for(var i:int = _objects.length; i >=0; i--)
			{
				var b:* = _objects[i];
				if (b is IsoObject ){
					if (b.position.equal(p)){
						_world.removeChild(b);
						_objects.splice(i,1);
					}
				}
			}
		}

		public function getAllBox():Array{
			return _objects ;
		}


		private function childPosExist(p:Point3D):Boolean{
			for(var i:int = _objects.length; i >=0; i--)
			{
				var b:* = _objects[i];
				if (b is IsoObject ){
					if (b.position.equal(p)){
						return true;
					}
				}
			}
			return false;
		}
		
		public function hasFloor(obj:IsoObject):Boolean{
			var rect:Rectangle = obj.rect;
			rect.offset(obj.vx,obj.vz);
			for(var i:int = _floors.length -1 ; i >=0 ; i--){
				var objB:IsoObject = _floors[i] as IsoObject;
				if(rect.intersects(objB.rect)){
					return true;
				}
			}
			return false ;
		}
		
		public function attackJudge(obj:IsoObject):Boolean{
			var weaponRect:Rectangle = obj.weapon;
			weaponRect.offset(obj.vx,obj.vz);
			for(var i:int = 0; i < _objects.length; i++)
			{
				var objB:IsoObject = _objects[i] as IsoObject;				
				if(obj != objB && weaponRect.intersects(objB.rect) && obj._type != objB._type && objB._type!= ElementType.BULLET){
					objB.attacked(obj.vx,obj.vz)
					return true
				}						
			}
			return false;
		}

		//判断obj是否能继续向前移动
		public function canMove(obj:IsoObject):Boolean
		{
			var rect:Rectangle = obj.rect;
			rect.offset(obj.vx, obj.vz);
			for(var i:int = 0; i < _objects.length; i++)
			{
				var objB:IsoObject = _objects[i] as IsoObject;				
				if(obj != objB && !objB.walkable && rect.intersects(objB.rect) && obj._type != objB._type)
				{
					return false;
				}
			}
			return true;
		}

		/**
		 *标记删除
		 * @return
		 *
		 */
		public function get deleteCell():Boolean
		{
			return _deleteCell;
		}

		public function set deleteCell(value:Boolean):void
		{
			_deleteCell = value;
		}


	}
}
