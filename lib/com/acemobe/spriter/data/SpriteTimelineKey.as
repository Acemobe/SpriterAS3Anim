package com.acemobe.spriter.data
{
	public class SpriteTimelineKey extends TimelineKey
	{
		public	var	folder:int; // index of the folder within the ScmlObject
		public	var	file:int;  
		public	var	useDefaultPivot:Boolean = true; // true if missing pivot_x and pivot_y in object tag
		public	var	pivot_x:Number = 0;
		public	var	pivot_y:Number = 1;
		
		public	var	spriteName:String = "";

		public function SpriteTimelineKey()
		{
			super();
		}
		
		public	override function parse (timelineXml:XML):void
		{
			super.parse(timelineXml);
			
			info.parse(timelineXml.object[0]);

			if (timelineXml.object[0].attribute("folder").length())
				folder = timelineXml.object[0].@folder;
			if (timelineXml.object[0].attribute("file").length())
				file = timelineXml.object[0].@file;
			if (timelineXml.attribute("pivot_x").length())
			{
				pivot_x = timelineXml.@pivot_x;
				useDefaultPivot = false;
			}
			if (timelineXml.attribute("pivot_y").length())
			{
				pivot_y = timelineXml.@pivot_y;
				useDefaultPivot = false;
			}
		}
		
		public	override function clone (clone:TimelineKey):void
		{
			super.clone(clone);
			
			var	c:SpriteTimelineKey = clone as SpriteTimelineKey;

			c.pivot_x = this.pivot_x;
			c.pivot_y = this.pivot_y;
			c.folder = this.folder;
			c.file = this.file;
			c.useDefaultPivot = this.useDefaultPivot;
		}
		
		public	override function paint():void
		{
			var	paintPivotX:int;
			var	paintPivotY:int;
			
			if (useDefaultPivot)
			{
//				paintPivotX = ScmlObject.activeCharacterMap[folder].files[file].pivotX;
//				paintPivotY = ScmlObject.activeCharacterMap[folder].files[file].pivotY;
			}
			else
			{
				paintPivotX = pivot_x;
				paintPivotY = pivot_y;
			}
			
			// paint image represented by
			// ScmlObject.activeCharacterMap[folder].files[file],fileReference 
			// at x,y,angle (counter-clockwise), offset by paintPivotX,paintPivotY		
		}    
		
		public	override function linearKey (keyB:TimelineKey, t:Number):TimelineKey
		{
			var returnKey:SpriteTimelineKey = new SpriteTimelineKey (); 
			clone (returnKey);
			returnKey.info = linearSpatialInfo (info, keyB.info, spin, t);
		
			if (!useDefaultPivot)
			{
				var	keyBSprite:SpriteTimelineKey = keyB as SpriteTimelineKey;
				
				returnKey.pivot_x = linear (pivot_x, keyBSprite.pivot_x, t);
				returnKey.pivot_y = linear (pivot_y, keyBSprite.pivot_y, t);
			}
			
			return returnKey;
		}
	}
}