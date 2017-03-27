package
{   
	import flash.display.*;
	import flash.events.*;
	import flash.ui.Keyboard;
	import com.sty.iso.*
	
	[SWF(backgroundColor=0xffffff,height=260,width=460)]
	public class MotionTest extends Sprite
	{
		private var world:IsoWorld;
		private var box:DrawnIsoBox;
		private var speed:Number = 20;
		public function MotionTest()
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
					var tile:DrawnIsoTile = new DrawnIsoTile(world.cellSize, 0xcccccc);
					tile.position = new Point3D(i * world.cellSize, 0, j * world.cellSize);
					world.addChildToFloor(tile);
				}
			}
			box = new DrawnIsoBox(world.cellSize, 0xff0000, world.cellSize);
			//把box摆在world中央
			box.x = world.cellSize*Math.round(world.cols/2);
			box.z = world.cellSize*Math.round(world.rows/2);
			world.addChildToWorld(box);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(Event.RESIZE,resizeHandler);
		}
		
		private function sizeInit():void{
			world.x = stage.stageWidth / 2; 
			world.y = 50;
		}
		
		
		private function resizeHandler(e:Event):void{           
			sizeInit();     
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{ 
			switch(event.keyCode)
			{
				case Keyboard.UP :
					box.vx = -speed;
					break;
				case Keyboard.DOWN :
					box.vx = speed;
					break;
				case Keyboard.LEFT :
					box.vz = speed;
					break;
				case Keyboard.RIGHT :
					box.vz = -speed;
					break;
				case Keyboard.END:                  
					box.vy = -speed;
					break;
				case Keyboard.HOME:                 
					box.vy = speed;
					break;
				default :
					break;
			}
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			box.vx = 0;
			box.vz = 0;
			box.vy = 0;
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void
		{
			box.x += box.vx;            
			box.z += box.vz;    
			box.y += box.vy;
			if (box.x<0){
				box.x =0;
			}
			else if(box.x>world.cellSize*(world.cols-1)){
				box.x = world.cellSize*(world.cols-1);
			}
			
			if (box.z<0){
				box.z =0;
			}
			else if(box.z>world.cellSize*(world.rows-1)){
				box.z = world.cellSize*(world.rows-1);
			}           
		}
	}
}