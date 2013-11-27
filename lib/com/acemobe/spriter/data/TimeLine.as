package com.acemobe.spriter.data
{
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
		
		public	function parse (timelineXml:XML):void
		{
			if (timelineXml.attribute("id").length())
				id = timelineXml.@id;
			if (timelineXml.attribute("name").length())
				name = timelineXml.@name;
			if (timelineXml.attribute("object_type").length())
			{
				if (timelineXml.@object_type == "sprite")
					objectType = SPRITE;
				if (timelineXml.@object_type == "bone")
					objectType = BONE;
			}
			
			for each(var timelineKeyXml:XML in timelineXml.key)
			{				
				var	timelineKey:TimelineKey;
				
				switch (objectType)
				{
					case	SPRITE:
						timelineKey = new SpriteTimelineKey ();
						break;
					case	BONE:
						timelineKey = new BoneTimelineKey ();
						break;
				}
				
				timelineKey.parse (timelineKeyXml);
				timelineKey.timelineID = id;

				keys.push (timelineKey);
			}
		}
	}
}