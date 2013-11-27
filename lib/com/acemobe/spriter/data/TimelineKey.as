package com.acemobe.spriter.data
{
	public class TimelineKey
	{
		public	static	var	INSTANT:int = 0;
		public	static	var	LINEAR:int = 1;
		public	static	var	QUADRATIC:int = 2;
		public	static	var	CUBIC:int = 3;

		public	var	id:int = 0;
		public	var	timelineID:int = 0;
		public	var	name:String = "";
		public	var	curveType:int = LINEAR;
		public	var	time:int = 0;
		public	var	c1:Number = 0;
		public	var	c2:Number = 0;
		public	var	spin:int = 1;

		public	var	info:SpatialInfo;
		
		public function TimelineKey ()
		{
			info = new SpatialInfo ();
		}

		public function clone (clone:TimelineKey):void
		{
			clone.id = this.id;
			clone.timelineID = this.timelineID;
			clone.name = this.name;
			clone.curveType = this.curveType;
			clone.time = this.time;
			clone.c1 = this.c1;
			clone.c2 = this.c2;
			clone.spin = this.spin;
			clone.info = this.info.clone ();
		}
		
		public	function parse (timelineXml:XML):void
		{
			if (timelineXml.attribute("id").length())
				id = timelineXml.@id;
			if (timelineXml.attribute("name").length())
				name = timelineXml.@name;
			if (timelineXml.attribute("time").length())
				time = timelineXml.@time;
			if (timelineXml.attribute("c1").length())
				c1 = timelineXml.@c1;
			if (timelineXml.attribute("c2").length())
				c2 = timelineXml.@c2;
			if (timelineXml.attribute("spin").length())
				spin = timelineXml.@spin;
			if (timelineXml.attribute("curveType").length())
			{
				switch (timelineXml.@curveType)
				{
					case	0:
						curveType = INSTANT;
						break;
				}
			}
		}
		
		public	function	paint ():void
		{
			
		}
		
		public	function interpolate(nextKey:TimelineKey, nextKeyTime:int, currentTime:Number):TimelineKey
		{
			return linearKey (nextKey, getTWithNextKey (nextKey, nextKeyTime, currentTime));
		}     
		
		public	function linearKey(keyB:TimelineKey, t:Number):TimelineKey
		{
			// overridden in inherited types  return linear(this,keyB,t);
			
			return null;
		}
		
		public	function getTWithNextKey(nextKey:TimelineKey, nextKeyTime:int, currentTime:Number):Number
		{
			if (curveType == INSTANT || time == nextKeyTime)
			{
				return 0;
			}
			
			var t:Number = (currentTime-time)/(nextKeyTime-time);
			
			if (curveType == LINEAR)
			{
				return t;        
			}
			else if (curveType == QUADRATIC)
			{
				return (quadratic(0.0,c1,1.0,t));
			}
			else if (curveType == CUBIC)
			{  
				return (cubic(0.0,c1,c2,1.0,t));
			}
			
			return 0; // Runtime should never reach here        
		}	
		
		public	function linear(a:Number, b:Number, t:Number):Number
		{
			return ((b-a)*t)+a;
		}
		
		public	function linearSpatialInfo(infoA:SpatialInfo, infoB:SpatialInfo, spin:int, t:Number):SpatialInfo
		{
			var	resultInfo:SpatialInfo = new SpatialInfo ();
			
			resultInfo.x = linear (infoA.x, infoB.x, t); 
			resultInfo.y = linear (infoA.y, infoB.y, t);  
			resultInfo.angle = angleLinear (infoA.angle, infoB.angle, spin, t); 
			resultInfo.scaleX = linear (infoA.scaleX, infoB.scaleX, t); 
			resultInfo.scaleY = linear (infoA.scaleY, infoB.scaleY, t); 
			resultInfo.a = linear (infoA.a, infoB.a, t);
			
			return resultInfo;
		}
		
		public	function angleLinear(angleA:Number, angleB:Number, spin:int, t:Number):Number
		{
			if(spin==0)
			{
				return angleA;
			}
			if(spin>0)
			{
				if((angleB-angleA)<0)
				{
					angleB+=360;
				}
			}
			else if(spin<0)
			{
				if((angleB-angleA)>0)
				{   
					if (Math.abs(angleB-angleA) < 180)
					{
						return linear (angleB, angleA, 1 - t);
					}
					else
						angleB-=360;
				}
			}
			
			return linear (angleA, angleB, t);
		}
		
		public	function quadratic(a:Number, b:Number, c:Number, t:Number):Number
		{
			return linear(linear(a,b,t),linear(b,c,t),t);
		}
		
		public	function cubic(a:Number, b:Number, c:Number, d:Number, t:Number):Number
		{
			return linear(quadratic(a,b,c,t),quadratic(b,c,d,t),t);
		}
	}
}