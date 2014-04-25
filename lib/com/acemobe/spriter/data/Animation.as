package com.acemobe.spriter.data
{
	import com.acemobe.spriter.SpriterAnimation;

	public class Animation
	{
		public	static	var	NO_LOOPING:int = 0;
		public	static	var	LOOPING:int = 1;
		
		public	var	id:int = 0;
		public	var	name:String = "";
		public	var	animationData:*;
		public	var	loopType:int = LOOPING;
		public	var	length:int = 0;
		public	var	loaded:Boolean = false;

		public	var	mainlineKeys:Array = [];
		public	var	timelines:Array = [];

		public	var	currentTime:int = 0;

		public	var	objectKeys:Array = [];
		public	var	transformedBoneKeys:Array = [];

		public function Animation()
		{
		}
		
		public	function parseXML (spriteAnim:SpriterAnimation):void
		{
			var	xml:XML = animationData as XML;
			
			id = xml.@id;
			length = xml.@length;

			if (xml.hasOwnProperty("@looping"))
			{
				if (xml.@looping == "true")
					loopType = LOOPING;
				else
					loopType = NO_LOOPING;
			}
			
			for each(var mainlineXml:XML in xml.mainline.key)
			{				
				var	mainline:MainlineKey = new MainlineKey ();
				mainline.parseXML (spriteAnim, mainlineXml);
				
				mainlineKeys.push (mainline);
			}

			for each(var timelineXml:XML in xml.timeline)
			{				
				var	timeline:TimeLine = new TimeLine ();
				timeline.parseXML (spriteAnim, timelineXml);
				
				timelines.push (timeline);
			}
			
			loaded = true;
		}
		
		public	function parse (spriteAnim:SpriterAnimation):void
		{
			id = animationData.id;
			length = animationData.length;
			
			if (animationData.hasOwnProperty("looping"))
			{
				if (animationData.looping == "true")
					loopType = LOOPING;
				else
					loopType = NO_LOOPING;
			}
			
			for each(var mainlineData:* in animationData.mainline.key)
			{				
				var	mainline:MainlineKey = new MainlineKey ();
				mainline.parse (spriteAnim, mainlineData);
				
				mainlineKeys.push (mainline);
			}
			
			for each(var timelineData:* in animationData.timeline)
			{				
				var	timeline:TimeLine = new TimeLine ();
				timeline.parse (spriteAnim, timelineData);
				
				timelines.push (timeline);
			}
			
			for each(var soundlineData:* in animationData.soundline)
			{				
/*				var	timeline:TimeLine = new TimeLine ();
				timeline.parse (spriteAnim, timelineData);
				
				timelines.push (timeline);
*/			}
			
			loaded = true;
		}
		
		public	function setCurrentTime(newTime:Number):void
		{
			if(loopType == NO_LOOPING)
			{
				currentTime = Math.min (newTime, length);
			}
			else if(loopType == LOOPING)
			{
				currentTime = newTime % length;
			}

			updateCharacter (mainlineKeyFromTime(currentTime), currentTime);
		}
		
		public	function updateCharacter(mainKey:MainlineKey, newTime:int):void
		{
			var	currentRef:Ref;
			var	currentKey:TimelineKey;
			
			transformedBoneKeys.length = 0;
			objectKeys.length = 0;
			
			for(var	b:int = 0; b < mainKey.boneRefs.length; b++)
			{
				currentRef = mainKey.boneRefs[b];
				
				if (mainKey.curveType != MainlineKey.INSTANT)
				{
					currentKey = keyFromRef (currentRef, newTime);
				}
				else
				{
					currentKey = timelines[currentRef.timeline].keys[currentRef.key].copy ();
				}
				
				if (currentRef.parent >= 0)
				{
					currentKey.unmapFromParent (transformedBoneKeys[currentRef.parent]);
				}
			
				transformedBoneKeys.push (currentKey);
			}
			
			for(var	o:int = 0; o < mainKey.objectRefs.length; o++)
			{
				currentRef = mainKey.objectRefs[o];
				if (mainKey.curveType != MainlineKey.INSTANT)
				{
					currentKey = keyFromRef (currentRef, newTime);
				}
				else
				{
					currentKey = timelines[currentRef.timeline].keys[currentRef.key].copy ();
				}
				
				if (currentRef.parent >= 0)
				{
					currentKey.unmapFromParent (transformedBoneKeys[currentRef.parent]);
				}
				
				objectKeys.push (currentKey);
			}
		}
		
		public	function mainlineKeyFromTime (time:int):MainlineKey
		{
			var	currentMainKey:int = 0;
			for (var m:int = 0; m < mainlineKeys.length; m++)
			{
				if(mainlineKeys[m].time <= currentTime)
				{
					currentMainKey = m;
				}
				
				if(mainlineKeys[m].time >= currentTime)
				{
					break;
				}
			}
			
			return mainlineKeys[currentMainKey];
		}	
		
		public	function keyFromRef(ref:Ref, newTime:int):TimelineKey
		{
			var timeline:TimeLine = timelines[ref.timeline];
			var	keyA:TimelineKey = timeline.keys[ref.key].copy ();

			if (timeline.keys.length == 1)
			{
				return keyA;
			}
			
			var	nextKeyIndex:int = ref.key + 1;
			
			if (nextKeyIndex >= timeline.keys.length)
			{
				if (loopType == LOOPING)
				{
					nextKeyIndex = 0; 
				}
				else
				{
					return keyA;
				}
			}
			
			var keyB:TimelineKey = timeline.keys[nextKeyIndex];
			var	keyBTime:int = keyB.time;
			
			if (keyBTime < keyA.time)
			{
				keyBTime = keyBTime + length;
			}
			
			keyA.interpolate (keyB, keyBTime, currentTime);			
			return keyA;
		}	
	}
}