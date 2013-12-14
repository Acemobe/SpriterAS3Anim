package com.acemobe.spriter.data
{
	import com.acemobe.spriter.SpriterAnimation;

	public class PointTimelineKey extends TimelineKey
	{
		public function PointTimelineKey()
		{
			super();
		}
		
		public	override function parse (spriteAnim:SpriterAnimation, timelineXml:XML):void
		{
			super.parse(spriteAnim, timelineXml);
			
			if (timelineXml.object[0].hasOwnProperty("@x"))
				x = timelineXml.object[0].@x;
			if (timelineXml.object[0].hasOwnProperty("@y"))
				y = -timelineXml.object[0].@y;
		}
		
		public	override function copy ():*
		{
			var	copy:TimelineKey = new SpriteTimelineKey ();
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