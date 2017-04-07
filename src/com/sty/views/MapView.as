package com.sty.views
{
	import com.sty.astar.AStar;
	import com.sty.astar.Grid;
	import com.sty.astar.Node;
	import com.sty.iso.DrawnIsoBox;
	import com.sty.iso.GraphicTile;
	import com.sty.iso.IsoObject;
	import com.sty.iso.IsoUtils;
	import com.sty.iso.IsoWorld;
	import com.sty.iso.Point3D;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
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
		
		private var astarGrid:Grid;
		private var gridSp:Sprite;
			
		public function MapView(_camera:CameraView)
		{
			camera   = _camera
			mapSp	 = new Sprite()
			playerSp = new Sprite();
			world    = new IsoWorld(col,row,cellSize);
			emptyPlace = new Array()
			enemys = new Vector.<IsoObject>;
			astarGrid = new Grid()
			astarGrid.creatGrid(col,row)
			
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
					//障碍物
					if(value == 3){
						var box:GraphicTile = new GraphicTile(40, Tile_Stone, 40, 71);
						box.position =new Point3D(i * world.cellSize, 0, j * world.cellSize);
						world.addChildToWorld(box);
						astarGrid.setWalkAble(i,j,false)
					}
					if(value == 2){
						emptyPlace.push(new Point(i,j))
					}
					if(value == 0){
						astarGrid.setWalkAble(i,j,false)
					}
					
				}
			}
			gridSp = new Sprite();
			this.addChild(gridSp);
			drawGird();
			addPlayer()
			addEnemy()
			var p:Point = IsoUtils.isoToScreen(hittestBox.position)
			camera.track(p)
		}
		
		private function drawGird():void{
			gridSp.graphics.clear()
			var arr:Array = astarGrid.nodeArrayList ; 
			for(var i:int = 0 ; i < astarGrid.gridRowNum ; i++){
				for(var j:int = 0 ; j < astarGrid.gridLineNum ; j++){
					var node:Node = arr[i][j];
					gridSp.graphics.lineStyle(0);
					gridSp.graphics.beginFill(getNodeColor(node),0.5);
					gridSp.graphics.drawRect(i*cellSize/2 , j *cellSize/2 , cellSize/2 , cellSize/2);
				}
			}
		}
		private function getNodeColor(_node:Node):uint
		{
			if(_node == astarGrid.startNode){return 0xff0000};
			if(_node == astarGrid.endNode){return 0xff0000} ;
			if(!_node.walkable){return 0x000000}
			if(_node.isPath){return 0x0000ff};
			if(_node.isFind){return 0x333333};
			return 0x00ff00 ;
			
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
				astarGrid.setStartNode(enemy.position.x/cellSize,enemy.position.z/cellSize);
				astarGrid.setEndNode(playerBox.position.x/cellSize,playerBox.position.z/cellSize);
				var path:Array = onPath();
				enemy.movePath = path;
			}
			
		}
		
		private function onPath():Array{
			var asta:AStar = new AStar();
			if(asta.setGrid(astarGrid)){
				var parr:Array = asta.getPath() ; 
				var posArr:Array = []
				var opens:Array = asta.getOpens();
				for(var i:int = 0 ; i <parr.length; i++){
					parr[i].isPath = true ;
					posArr.push(parr[i]._x,parr[i]._y);
				}
				drawGird();
				return posArr;
			}
			return null;
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
			if(!hasFloor){
				hittestBox.drop();
				playerBox.drop();
			
			}else if(hasFloor && playerPos.y >= 0){
				playerBox.isDrop = false
				hittestBox.isDrop = false
			}
			hittestBox.onRender();
			playerBox.onRender();
			
			for(var i:int = 0 ; i < enemys.length ; i ++){
				enemys[i].onRender();
			}
		}
	}
}