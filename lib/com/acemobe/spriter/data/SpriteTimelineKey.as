package com.acemobe.spriter.data
{
	import com.acemobe.spriter.SpriterAnimation;

	public class SpriteTimelineKey extends TimelineKey
	{
		public	var	folder:int; // index of the folder within the ScmlObject
		public	var	file:int;  
		public	var	useDefaultPivot:Boolean = true; // true if missing pivot_x and pivot_y in object tag
		public	var	pivot_x:Number = 0;
		public	var	pivot_y:Number = 1;
		
		public	var	spriteName:String = "";
		public	var	spriteName2:String = "";
		public	var	fileRef:File;

		public function SpriteTimelineKey()
		{
			super();
		}
		
		public	override function parse (spriteAnim:SpriterAnimation, timelineXml:XML):void
		{
			super.parse(spriteAnim, timelineXml);
			
			info.parse(timelineXml.object[0]);

			if (timelineXml.object[0].hasOwnProperty("@folder"))
				folder = timelineXml.object[0].@folder;
			if (timelineXml.object[0].hasOwnProperty("@file"))
				file = timelineXml.object[0].@file;
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
			
			var	folderRef:Folder = spriteAnim.folders[folder] as Folder;
			fileRef = folderRef.files[file] as File;
			spriteName = fileRef.name;
			
			spriteName2 = spriteName;
			var	pos:int = spriteName2.lastIndexOf("/");
			if (pos != -1)
			{
				spriteName2 = spriteName2.substr(pos + 1);
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
			c.folder = this.folder;
			c.file = this.file;
			c.useDefaultPivot = this.useDefaultPivot;
			c.spriteName = this.spriteName;
			c.spriteName2 = this.spriteName2;
			c.fileRef = this.fileRef;
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
		
		public	override function linearKey (keyB:TimelineKey, t:Number):void
		{
			linearSpatialInfo (info, keyB.info, spin, t);
		
			if (!useDefaultPivot)
			{
				var	keyBSprite:SpriteTimelineKey = keyB as SpriteTimelineKey;
				
				pivot_x = linear (pivot_x, keyBSprite.pivot_x, t);
				pivot_y = linear (pivot_y, keyBSprite.pivot_y, t);
			}
		}
	}
}