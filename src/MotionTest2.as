package
{
	import com.sty.iso.*
	import flash.display.*;
	import flash.events.*;
	import flash.filters.BlurFilter;
	
	[SWF(backgroundColor=0xffffff,height=300,width=420)]
	public class MotionTest2 extends Sprite
	{
		private var world:IsoWorld;
		private var box:DrawnIsoBox;
		private var shadow:DrawnIsoTile;
		private var gravity:Number = 2;
		private var friction:Number = 0.95;
		private var bounce:Number = -0.9;
		private var filter:BlurFilter;
		public function MotionTest2()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			world = new IsoWorld();
			sizeInit();
			addChild(world);
			for(var i:int = 0; i < world.cols; i++)
			{
				for(var j:int = 0; j < world.rows; j++)
				{
					var tile:DrawnIsoTile = new DrawnIsoTile(20, 0xcccccc);
					tile.position = new Point3D(i * world.cellSize, 0, j * world.cellSize);
					world.addChildToFloor(tile);
				}
			}
			box = new DrawnIsoBox(world.cellSize, 0xff0000, world.cellSize);
			//把box摆在world中央
			box.x = world.cellSize*Math.round(world.cols/2);
			box.z = world.cellSize*Math.round(world.rows/2);
			world.addChildToWorld(box);
			shadow = new DrawnIsoTile(world.cellSize, 0);
			shadow.alpha = 0.5;
			world.addChildToFloor(shadow);
			filter = new BlurFilter();
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.CLICK, onClick);
			stage.addEventListener(Event.RESIZE,resizeHandler);
		} 
		
		
		private function sizeInit():void{
			world.x = stage.stageWidth / 2; 
			world.y = 100;
		}
		
		
		private function resizeHandler(e:Event):void{           
			sizeInit();     
		}
		
		private function onClick(event:MouseEvent):void
		{
			box.vx = Math.random() * 20 - 10;
			box.vy = -5 -Math.random() * 25;
			box.vz = Math.random() * 20 - 10;
		}
		
		private function onEnterFrame(event:Event):void
		{
			box.vy += gravity;//重力加速度
			box.x += box.vx;
			box.y += box.vy;
			box.z += box.vz;
			if(box.x > (world.cols-1)*world.cellSize)
			{
				box.x = (world.cols-1)*world.cellSize;
				box.vx *= bounce;//反弹
			}
			else if(box.x < 0)
			{
				box.x = 0;
				box.vx *= bounce;
			}
			if(box.z > (world.rows-1)*world.cellSize)
			{
				box.z = (world.rows-1)*world.cellSize;
				box.vz *= bounce;
			}
			else if(box.z < 0)
			{
				box.z = 0;
				box.vz *= bounce;
			}
			if(box.y > 0)
			{
				box.y = 0;
				box.vy *= bounce;
			}
			//摩擦力
			box.vx *= friction;
			box.vy *= friction;
			box.vz *= friction;
			//影子坐标同步
			shadow.x = box.x;
			shadow.z = box.z;
			//蚊子模糊
			filter.blurX = filter.blurY = -box.y * .25;
			shadow.filters = [filter];
		}
	}
}