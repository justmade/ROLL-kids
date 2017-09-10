package
{
	import com.sty.iso.DrawnIsoTile;
	import com.sty.iso.IsoUtils;
	import com.sty.iso.Point3D;
	import com.sty.iso.StgIsoTile;
	
	import flash.display.Sprite;
	import flash.geom.Point;

	public class StaggeredMap extends Sprite
	{
		public function StaggeredMap()
		{
			for(var i:int = 0; i < 10; i++)
			{
				for(var j:int = 0; j <20; j++)
				{
					var tile:StgIsoTile = new StgIsoTile(20, 0xcccccc);
					trace("==i==",i,j)
					tile.position = new Point( i * 20, j * 20);
					this.addChild(tile)
				}
			}
		}
	}
}