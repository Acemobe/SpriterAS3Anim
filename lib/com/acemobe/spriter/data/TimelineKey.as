package com.acemobe.spriter.data
{
	import com.acemobe.spriter.Spriter;
	import com.acemobe.spriter.SpriterAnimation;
	
	import starling.utils.deg2rad;

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

//		SpatialInfo;
		public	var	x:Number = 0; 
		public	var	y:Number = 0; 
		public	var	angle:Number = 0;
		public	var	scaleX:Number = 1; 
		public	var	scaleY:Number = 1; 
		public	var	a:Number = 1;
		
		public function TimelineKey ()
		{
		}
		
		public	function copy ():*
		{
			var	copy:TimelineKey = new TimelineKey ();
			clone (copy);
			
			return copy;
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
	
			clone.x = this.x;
			clone.y = this.y;
			clone.angle = this.angle;
			clone.scaleX = this.scaleX;
			clone.scaleY = this.scaleY;
			clone.a = this.a;
//			this.info.clone (clone.info);
		}
		
		public	function parse (spriteAnim:SpriterAnimation, timelineXml:XML):void
		{
			if (timelineXml.hasOwnProperty("@id"))
				id = timelineXml.@id;
			if (timelineXml.hasOwnProperty("@name"))
				name = timelineXml.@name;
			if (timelineXml.hasOwnProperty("@time"))
				time = timelineXml.@time;
			if (timelineXml.hasOwnProperty("@c1"))
				c1 = timelineXml.@c1;
			if (timelineXml.hasOwnProperty("@c2"))
				c2 = timelineXml.@c2;
			if (timelineXml.hasOwnProperty("@spin"))
				spin = timelineXml.@spin;
			if (timelineXml.hasOwnProperty("@curveType"))
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
		
		public	function interpolate(nextKey:TimelineKey, nextKeyTime:int, currentTime:Number):void
		{
			linearKey (nextKey, getTWithNextKey (nextKey, nextKeyTime, currentTime));
		}     
		
		public	function linearKey(keyB:TimelineKey, t:Number):void
		{
			// overridden in inherited types  return linear(this,keyB,t);
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
		
		public	function linearSpatialInfo(infoA:TimelineKey, infoB:TimelineKey, spin:int, t:Number):void
		{
			x = linear (infoA.x, infoB.x, t); 
			y = linear (infoA.y, infoB.y, t);  
			angle = angleLinear (infoA.angle, infoB.angle, spin, t); 
			scaleX = linear (infoA.scaleX, infoB.scaleX, t); 
			scaleY = linear (infoA.scaleY, infoB.scaleY, t); 
			a = linear (infoA.a, infoB.a, t);
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
		
		public	function	unmapFromParent(parentInfo:TimelineKey):void
		{
			angle += parentInfo.angle;
			scaleX *= parentInfo.scaleX;
			scaleY *= parentInfo.scaleY;
			a *= parentInfo.a;
			
			if (x != 0 || y != 0)  
			{
				var	new_angle:Number = deg2rad (Spriter.fixRotation (parentInfo.angle));
				var	preMultX:Number = x * parentInfo.scaleX;
				var	preMultY:Number = y * parentInfo.scaleY;
				var	s:Number = Math.sin (new_angle);
				var	c:Number = Math.cos (new_angle);
				x = (preMultX * c) - (preMultY * s);
				y = (preMultX * s) + (preMultY * c);
				x += parentInfo.x;
				y += parentInfo.y;
			}
			else 
			{
				// Mandatory optimization for future features           
				x = parentInfo.x;
				y = parentInfo.y;
			}
		}
	}
}