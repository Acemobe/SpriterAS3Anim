package com.acemobe.spriter.data
{
	import com.acemobe.spriter.SpriterAnimation;

	public class BoneTimelineKey extends TimelineKey
	{
		public	var	length:int = 200;
		public	var	width:int = 10;
		public	var	paintDebugBones:Boolean = true;

		public function BoneTimelineKey()
		{
			super();
		}
		
		public	override function parse (spriteAnim:SpriterAnimation, timelineXml:XML):void
		{
			super.parse(spriteAnim, timelineXml);

			info.parse(timelineXml.bone[0]);

			if (timelineXml.hasOwnProperty("@length"))
				length = timelineXml.@length;
			if (timelineXml.hasOwnProperty("@width"))
				width = timelineXml.@width;
		}
		
		public	override function paint():void
		{
			if (paintDebugBones)
			{
				var	drawLength:Number = length * info.scaleX;
				var	drawHeight:Number = width * info.scaleY;
				// paint debug bone representation 
				// e.g. line starting at x,y,at angle, 
				// of length drawLength, and height drawHeight
			}
		}    
		
		public	override function copy ():*
		{
			var	copy:TimelineKey = new BoneTimelineKey ();
			clone (copy);
			
			return copy;
		}

		public	override function clone (clone:TimelineKey):void
		{
			super.clone(clone);
			
			var	c:BoneTimelineKey = clone as BoneTimelineKey;
			
			c.length = this.length;
			c.width = this.width;
		}
		
		public	override function linearKey (keyB:TimelineKey, t:Number):void
		// keyB must be BoneTimelineKeys
		{
			linearSpatialInfo(info, keyB.info, spin, t);
			
			if (paintDebugBones)
			{
				var keyBBone:BoneTimelineKey = keyB as BoneTimelineKey; 
				length = linear (length, keyBBone.length, t);
				width = linear (width, keyBBone.width, t);
			}
		}
	}
}