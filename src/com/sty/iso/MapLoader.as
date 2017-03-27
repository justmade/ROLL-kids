package com.sty.iso
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	
	public class MapLoader extends EventDispatcher
	{
		private var _grid:Array;
		private var _loader:URLLoader;
		private var _tileTypes:Object;	
		
		public function MapLoader()
		{
			_tileTypes = new Object();
		}       
		
		public function loadMap(url:String):void
		{
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onLoad);
			_loader.load(new URLRequest(url));
		}
		
		public function getData(_data:*):void{
			_grid = new Array();
//			var data:String = _loader.data;
			var data:String =_data
			//注：在不同的系统中的回车符的定义不同，有些系统用\r\n来表示回车，有些则只使用\n，所以这里要先过滤掉\r
			if (data.indexOf("\r")!=-1){                
				var myPattern:RegExp = /\r/g;               
				data =  data.replace(myPattern,"");         
			}
			trace("data",data);
			var lines:Array = data.split("\n");
			for(var i:int = 0; i < lines.length; i++)
			{
				var line:String = lines[i];   
				
				if(isDefinition(line))//如果是类型定义，则解析类型定义
				{
					parseDefinition(line);
				}                   
				else if(!lineIsEmpty(line) && !isComment(line))
				{
					var cells:Array = line.split(" ");
					_grid.push(cells);
				}
			}
			//触发Event.COMPLETE事件
			dispatchEvent(new Event(Event.COMPLETE));           
		}
		
		private function onLoad(event:Event):void
		{
			getData(_loader.data)
		}
		
		//分析类型定义
		private function parseDefinition(line:String):void
		{           
			var tokens:Array = line.split(" "); 
			//trace(line);
			//类似 下面中的某一行
			//# 1 type:GraphicTile graphicClass:MapTest_Tile02 xoffset:20 yoffset:30 walkable:false
			//# 2 type:DrawnIsoBox color:0xff6666 walkable:false height:20
			//# 3 type:DrawnIsoTile color:0x6666ff walkable:false
			tokens.shift();//删除掉第一个字符#      
			var symbol:String = tokens.shift() as String;//得到标志字符，即“1”
			
			var definition:Object = new Object();
			for(var i:int = 0; i < tokens.length; i++)
			{
				var key:String = tokens[i].split(":")[0];
				var val:String = tokens[i].split(":")[1];
				definition[key] = val;//将类似 type:GraphicTile graphicClass:MapTest_Tile02 xoffset:20 yoffset:30 walkable:false 以key-value的结构保存到object中
			}
			//trace("symbol：",symbol);
			setTileType(symbol, definition);
		}
		
		
		//设置贴片类型
		public function setTileType(symbol:String, definition:Object):void
		{
			_tileTypes[symbol] = definition;
		}       
		
		//创建地图
		public function makeWorld(size:Number):IsoWorld
		{
			var world:IsoWorld = new IsoWorld();
			for(var i:int = 0; i < _grid.length; i++)
			{
				for(var j:int = 0; j < _grid[i].length; j++)
				{
					var cellType:String = _grid[i][j];
					var cell:Object = _tileTypes[cellType];
					var tile:IsoObject;
					switch(cell.type)                       
					{
						case "DrawnIsoTile" :
							tile = new DrawnIsoTile(size, parseInt(cell.color), parseInt(cell.height));
							break;
						case "DrawnIsoBox" :
							tile = new DrawnIsoBox(size, parseInt(cell.color), parseInt(cell.height));
							break;
						case "GraphicTile" :
							var graphicClass:Class = getDefinitionByName(cell.graphicClass) as Class;
							tile = new GraphicTile(size, graphicClass, parseInt(cell.xoffset), parseInt(cell.yoffset));
							break;
						default :
							tile = new IsoObject(size);
							break;
					}
					
					var d:DrawnIsoTile = new DrawnIsoTile(20,0xFFFFFF,0);
					d.position = new Point3D(i * world.cellSize, 0, j * world.cellSize);
					world.addChildToFloor(d);
					
					tile.walkable = cell.walkable == true;//强制设置所有对象为可穿越(当然这是可选的，非必须)
					tile.x = j * size;
					tile.z = i * size;
					world.addChildToWorld(tile);
				}
			}
			return world;
		}
		
		//是否空行(只有该行有一个字符不为" "就算过了)
		private function lineIsEmpty(line:String):Boolean
		{
			for(var i:int = 0; i < line.length; i++)
			{
				if(line.charAt(i) != " ") return false;
			}
			return true;
		}
		
		
		//判断该行是否为注释行
		private function isComment(line:String):Boolean
		{
			return line.indexOf("//") == 0;
		}
		
		//判断该行是否为“类型定义”
		private function isDefinition(line:String):Boolean
		{
			return line.indexOf("#") == 0;
		}
	}
}