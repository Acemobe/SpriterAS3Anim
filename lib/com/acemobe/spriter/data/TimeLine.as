package com.acemobe.spriter.data
{
	import com.acemobe.spriter.SpriterAnimation;

	public class TimeLine
	{
		public	static	var	SPRITE:int = 0;
		public	static	var	BONE:int = 1;
		public	static	var	BOX:int = 2;
		public	static	var	POINT:int = 3;
		public	static	var	SOUND:int = 4;
		public	static	var	ENTITY:int = 5;
		public	static	var	VARIABLE:int = 6;
		
		public	var	id:int = 0;
		public	var	name:String = "";
		public	var	objectType:int = 0;

		public	var	keys:Array = [];

		public function TimeLine()
		{
		}
		
		public	function parseXML (spriteAnim:SpriterAnimation, timelineXml:XML):void
		{
			if (timelineXml.hasOwnProperty("@id"))
				id = timelineXml.@id;
			if (timelineXml.hasOwnProperty("@name"))
				name = timelineXml.@name;
			if (timelineXml.hasOwnProperty("@object_type"))
			{
				if (timelineXml.@object_type == "sprite")
					objectType = SPRITE;
				if (timelineXml.@object_type == "bone")
					objectType = BONE;
				if (timelineXml.@object_type == "box")
					objectType = BOX;
				if (timelineXml.@object_type == "point")
					objectType = POINT;
			}
			
			for each(var timelineKeyXml:XML in timelineXml.key)
			{				
				var	timelineKey:TimelineKey = null;
				
				switch (objectType)
				{
					case	SPRITE:
						timelineKey = new SpriteTimelineKey ();
						break;
					case	BONE:
						timelineKey = new BoneTimelineKey ();
						break;
					case	BOX:
						timelineKey = new BoxTimelineKey ();
						break;
					case	POINT:
						timelineKey = new PointTimelineKey ();
						break;
				}
				
				if (timelineKey)
				{
					timelineKey.parseXML (spriteAnim, timelineKeyXml);
					timelineKey.timelineID = id;
					timelineKey.timeline = this;
					
					keys.push (timelineKey);
				}
			}
		}

		public	function parse (spriteAnim:SpriterAnimation, timelineData:*):void
		{
			id = timelineData.id;
			name = timelineData.name;
			
			if (timelineData.object_type == "sprite")
				objectType = SPRITE;
			else if (timelineData.object_type == "bone")
				objectType = BONE;
			else if (timelineData.object_type == "box")
				objectType = BOX;
			else if (timelineData.object_type == "point")
				objectType = POINT;
			
			for each(var timelineKeyData:* in timelineData.key)
			{				
				var	timelineKey:TimelineKey = null;
				
				switch (objectType)
				{
					case	SPRITE:
						timelineKey = new SpriteTimelineKey ();
						break;
					case	BONE:
						timelineKey = new BoneTimelineKey ();
						break;
					case	BOX:
						timelineKey = new BoxTimelineKey ();
						break;
					case	POINT:
						timelineKey = new PointTimelineKey ();
						break;
				}
				
				if (timelineKey)
				{
					timelineKey.parse (spriteAnim, timelineKeyData);
					timelineKey.timelineID = id;
					timelineKey.timeline = this;
					
					keys.push (timelineKey);
				}
			}
		}
	}
}