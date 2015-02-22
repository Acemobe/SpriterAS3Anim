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
		
		public	override function parseXML (spriteAnim:SpriterAnimation, timelineXml:XML):void
		{
			super.parseXML(spriteAnim, timelineXml);
			
			if (timelineXml.bone[0].hasOwnProperty("@x"))
				x = timelineXml.bone[0].@x;
			if (timelineXml.bone[0].hasOwnProperty("@y"))
				y = -timelineXml.bone[0].@y;
			if (timelineXml.bone[0].hasOwnProperty("@angle"))
				angle = timelineXml.bone[0].@angle;
			if (timelineXml.bone[0].hasOwnProperty("@scale_x"))
				scaleX = timelineXml.bone[0].@scale_x;
			if (timelineXml.bone[0].hasOwnProperty("@scale_y"))
				scaleY = timelineXml.bone[0].@scale_y;
			if (timelineXml.bone[0].hasOwnProperty("@a"))
				a = timelineXml.bone[0].@a;
			
			if (timelineXml.hasOwnProperty("@length"))
				length = timelineXml.@length;
			if (timelineXml.hasOwnProperty("@width"))
				width = timelineXml.@width;
		}
		
		public	override function parse (spriteAnim:SpriterAnimation, timelineData:*):void
		{
			super.parse (spriteAnim, timelineData);
			
			if (timelineData.bone.hasOwnProperty("x"))
				x = timelineData.bone.x;
			if (timelineData.bone.hasOwnProperty("y"))
				y = -timelineData.bone.y;
			if (timelineData.bone.hasOwnProperty("angle"))
				angle = timelineData.bone.angle;
			if (timelineData.bone.hasOwnProperty("scale_x"))
				scaleX = timelineData.bone.scale_x;
			if (timelineData.bone.hasOwnProperty("scale_y"))
				scaleY = timelineData.bone.scale_y;
			if (timelineData.bone.hasOwnProperty("a"))
				a = timelineData.bone.a;
			
			if (timelineData.hasOwnProperty("length"))
				length = timelineData.length;
			if (timelineData.hasOwnProperty("width"))
				width = timelineData.width;
		}
		
		public	override function paint():void
		{
			if (paintDebugBones)
			{
				var	drawLength:Number = length * scaleX;
				var	drawHeight:Number = width * scaleY;
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
			linearSpatialInfo(this, keyB, spin, t);

			if (paintDebugBones)
			{
				var keyBBone:BoneTimelineKey = keyB as BoneTimelineKey; 
				length = linear (length, keyBBone.length, t);
				width = linear (width, keyBBone.width, t);
			}
		}
	}
}