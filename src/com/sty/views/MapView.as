package com.sty.views
{
	import com.sty.iso.DrawnIsoBox;
	import com.sty.iso.DrawnIsoTile;
	import com.sty.iso.GraphicTile;
	import com.sty.iso.IsoObject;
	import com.sty.iso.IsoUtils;
	import com.sty.iso.IsoWorld;
	import com.sty.iso.Point3D;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.media.Camera;
	
	import data.ElementType;
	import data.MapData;

	public class MapView extends Sprite
	{
		[Embed(source="../../../grass.png")]
		private var Tile_Grass:Class
		
		[Embed(source="../../../stone.png")]
		private var Tile_Stone:Class
		
		private var world:IsoWorld;
		
		private var hittestBox:DrawnIsoBox;
		
		private var playerBox:DrawnIsoBox
		
		private var mapSp:Sprite;
		
		private var playerSp:Sprite
		
		private var camera:CameraView
		
		//z
		private var row:int = 10;
		//x
		private var col:int = 10;
		
		private var cellSize:int = 40
		
		private var playerDrop:Boolean = false
			
		private var emptyPlace:Array ;
		
		private var enemys:Vector.<IsoObject>;
			
		public function MapView(_camera:CameraView)
		{
			camera   = _camera
			mapSp	 = new Sprite()
			playerSp = new Sprite();
			world    = new IsoWorld(col,row,cellSize);
			emptyPlace = new Array()
			enemys = new Vector.<IsoObject>;
			this.addChild(mapSp)
			this.addChild(playerSp)
			mapSp.addChild(world);
			
			var map:Array = MapData.Maps[0];
			for(var i:int = 0; i < world.cols; i++)
			{
				for(var j:int = 0; j < world.rows; j++)
				{
					var index:int = j * 10 + i
					var value:int = map[index]
					if (value != 0){
						var tile:GraphicTile = new GraphicTile(40, Tile_Grass, 40, 20);
						tile.position = new Point3D(i * world.cellSize, 0, j * world.cellSize);
						world.addChildToFloor(tile);
						
					}
					if(value == 3){
						var box:GraphicTile = new GraphicTile(40, Tile_Stone, 40, 71);
						box.position =new Point3D(i * world.cellSize, 0, j * world.cellSize);
						world.addChildToWorld(box);
					}
					if(value == 2){
						emptyPlace.push(new Point(i,j))
					}
					
				}
			}
			addPlayer()
			addEnemy()
			var p:Point = IsoUtils.isoToScreen(hittestBox.position)
			camera.track(p)
		}
		
		private function addPlayer():void{
			var box:DrawnIsoBox = new DrawnIsoBox(world.cellSize/2, Math.random() * 0xffffff, world.cellSize/2,0.0,ElementType.PLAYER);
			var pos:Point3D = new Point3D(0,0,0)
			box.position = pos;
			world.addChildToWorld(box);
			hittestBox = box
				
			var box:DrawnIsoBox = new DrawnIsoBox(world.cellSize/2, Math.random() * 0xffffff, world.cellSize/2,1,ElementType.PLAYER);
			var pos:Point3D = new Point3D(0,0,0)
			box.position = pos;
			world.addChildToWorld(box);
			playerBox = box
		}
		
		private function addEnemy():void{
			for(var i:int = 0 ; i < 5 ; i++){
				var index:int = emptyPlace.length * Math.random();
				var value:Point = emptyPlace[index];
				emptyPlace.splice(index,1);
				var enemy:DrawnIsoBox = new DrawnIsoBox(world.cellSize/2, 0xff0000, world.cellSize/2,1,ElementType.ENEMY)
				var pos:Point3D = new Point3D(value.x * world.cellSize, 0, value.y * world.cellSize)
				enemy.position = pos;
				world.addChildToWorld(enemy);
				
				enemys.push(enemy)
			}
		}
		
		public function setKeyPoint(point_3d:Point3D):void{
			hittestBox.vx = point_3d.x * (world.cellSize/20)
			hittestBox.vz = point_3d.z * (world.cellSize/20)
			hittestBox.onRender();
			playerBox.onRender();
			var canMove:Boolean =  world.canMove(hittestBox)	
			if(canMove){
				playerBox.vx = point_3d.x * (world.cellSize/20)
				playerBox.vz = point_3d.z * (world.cellSize/20)
			}else{
				playerBox.vx = 0
				playerBox.vz = 0
				hittestBox.vx = -point_3d.x * (world.cellSize/20)
				hittestBox.vz = -point_3d.z * (world.cellSize/20)
			}
			world.sort()
		}
		
		public function onRender():void{
			//平时不跟随跳动
			var playerPos:Point3D = new Point3D(playerBox.position.x,0,playerBox.position.z)
			if(playerBox.isDrop){
				playerPos = new Point3D(playerBox.position.x,playerBox.position.y,playerBox.position.z)
			}
			var p:Point = IsoUtils.isoToScreen(playerPos)
			camera.track(p)
			var px:Number = camera.location.x;
			var py:Number = camera.location.y;
			mapSp.x = -px
			mapSp.y = -py	
				
			var hasFloor:Boolean = world.hasFloor(hittestBox)
			if(!hasFloor && !playerDrop){
				playerDrop = true
				hittestBox.drop();
				playerBox.drop();
			}
			hittestBox.onRender();
			playerBox.onRender();
			
			for(var i:int = 0 ; i < enemys.length ; i ++){
				enemys[i].onRender();
			}
		}
	}
}