package com.acemobe.spriter.data
{
	public class BoneTimelineKey extends TimelineKey
	{
		public	var	length:int = 200;
		public	var	width:int = 10;
		public	var	paintDebugBones:Boolean = true;

		public function BoneTimelineKey()
		{
			super();
		}
		
		public	override function parse (timelineXml:XML):void
		{
			super.parse(timelineXml);

			info.parse(timelineXml.bone[0]);

			if (timelineXml.attribute("length").length())
				length = timelineXml.@length;
			if (timelineXml.attribute("width").length())
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
		
		public	override function clone (clone:TimelineKey):void
		{
			super.clone(clone);
			
			var	c:BoneTimelineKey = clone as BoneTimelineKey;
			
			c.length = this.length;
			c.width = this.width;
		}
		
		public	override function linearKey (keyB:TimelineKey, t:Number):TimelineKey
		// keyB must be BoneTimelineKeys
		{
			var	returnKey:BoneTimelineKey = new BoneTimelineKey ();
			clone (returnKey);
			returnKey.info = linearSpatialInfo(info, keyB.info, spin, t);
			
			if (paintDebugBones)
			{
				var keyBBone:BoneTimelineKey = keyB as BoneTimelineKey; 
				returnKey.length = linear (length, keyBBone.length, t);
				returnKey.width = linear (width, keyBBone.width, t);
			}
			
			return returnKey;
		}
	}
}