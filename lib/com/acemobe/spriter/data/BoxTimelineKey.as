package com.acemobe.spriter.data
{
	import com.acemobe.spriter.SpriterAnimation;

	public class BoxTimelineKey extends TimelineKey
	{
		public	var	useDefaultPivot:Boolean = true; // true if missing pivot_x and pivot_y in object tag
		public	var	pivot_x:Number = 0;
		public	var	pivot_y:Number = 1;

		public function BoxTimelineKey()
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
			if (timelineXml.object[0].hasOwnProperty("@scale_x"))
				scaleX = timelineXml.object[0].@scale_x;
			if (timelineXml.object[0].hasOwnProperty("@scale_y"))
				scaleY = timelineXml.object[0].@scale_y;
			if (timelineXml.hasOwnProperty("@pivot_x"))
			{
				pivot_x = timelineXml.@pivot_x;
				useDefaultPivot = false;
			}
			if (timelineXml.hasOwnProperty("@pivot_y"))
			{
				pivot_y = timelineXml.@pivot_y;
				useDefaultPivot = false;
			}
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
			
			var	c:SpriteTimelineKey = clone as SpriteTimelineKey;
			
			c.pivot_x = this.pivot_x;
			c.pivot_y = this.pivot_y;
			c.useDefaultPivot = this.useDefaultPivot;
		}
		
		public	override function paint():void
		{
			var	paintPivotX:int;
			var	paintPivotY:int;
			
			if (useDefaultPivot)
			{
				paintPivotX = 0;
				paintPivotY = 1;
			}
			else
			{
				paintPivotX = pivot_x;
				paintPivotY = pivot_y;
			}
		}    
		
		public	override function linearKey (keyB:TimelineKey, t:Number):void
		{
			linearSpatialInfo (this, keyB, spin, t);
			
			if (!useDefaultPivot)
			{
				var	keyBSprite:SpriteTimelineKey = keyB as SpriteTimelineKey;
				
				pivot_x = linear (pivot_x, keyBSprite.pivot_x, t);
				pivot_y = linear (pivot_y, keyBSprite.pivot_y, t);
			}
		}
	}
}