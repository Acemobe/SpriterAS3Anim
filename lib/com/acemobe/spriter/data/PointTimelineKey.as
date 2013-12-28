package com.acemobe.spriter.data
{
	import com.acemobe.spriter.SpriterAnimation;

	public class PointTimelineKey extends TimelineKey
	{
		public function PointTimelineKey()
		{
			super();
		}
		
		public	override function parseXML (spriteAnim:SpriterAnimation, timelineXml:XML):void
		{
			super.parseXML(spriteAnim, timelineXml);
			
			if (timelineXml.object[0].hasOwnProperty("@x"))
				x = timelineXml.object[0].@x;
			if (timelineXml.object[0].hasOwnProperty("@y"))
				y = -timelineXml.object[0].@y;
		}
		
		public	override function parse (spriteAnim:SpriterAnimation, timelineData:*):void
		{
			super.parse(spriteAnim, timelineData);
			
			if (timelineData.object.hasOwnProperty("x"))
				x = timelineData.object.x;
			if (timelineData.object.hasOwnProperty("y"))
				y = -timelineData.object.y;
		}
		
		public	override function copy ():*
		{
			var	copy:TimelineKey = new PointTimelineKey ();
			clone (copy);
			
			return copy;
		}
		
		public	override function clone (clone:TimelineKey):void
		{
			super.clone(clone);
		}
		
		public	override function paint():void
		{
		}    
		
		public	override function linearKey (keyB:TimelineKey, t:Number):void
		{
			linearSpatialInfo (this, keyB, spin, t);
		}
	}
}