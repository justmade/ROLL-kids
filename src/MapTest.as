package
{
	import com.sty.iso.*
	import flash.display.*;
	import flash.events.Event;
	
	[SWF(backgroundColor=0xffffff,height=260,width=460)]
	public class MapTest extends Sprite
	{
		private var _world:IsoWorld;
		private var _floor:IsoWorld;
		private var mapLoader:MapLoader;
		
		
		
		public function MapTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			mapLoader = new MapLoader();
			mapLoader.addEventListener(Event.COMPLETE, onMapComplete);
			mapLoader.loadMap("map.txt");//map.txt里就是刚才提到的地图配置信息
			
			stage.addEventListener(Event.RESIZE,resizeHandler);     
		}
		
		private function sizeInit():void{
			if (_world!=null){
				_world.x = stage.stageWidth / 2;    
				_world.y = 50;
			}
		}
		
		
		private function resizeHandler(e:Event):void{           
			sizeInit();     
		}
		
		private function onMapComplete(event:Event):void
		{
			_world = mapLoader.makeWorld(20);           
			addChild(_world);           
			sizeInit();
		}
	}
}