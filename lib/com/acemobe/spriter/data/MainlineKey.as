package com.acemobe.spriter.data
{
	import com.acemobe.spriter.SpriterAnimation;

	public class MainlineKey
	{
		public	static	var	INSTANT:int = 0;
		public	static	var	LINEAR:int = 1;
		public	static	var	QUADRATIC:int = 2;
		public	static	var	CUBIC:int = 3;

		public	var	id:int = 0;
		public	var	time:int = 0;
		public	var	curveType:int = LINEAR;
		public	var	boneRefs:Array = [];
		public	var	objectRefs:Array = [];
		
		public function MainlineKey()
		{
		}
		
		public	function parseXML (spriteAnim:SpriterAnimation, animationXml:XML):void
		{
			id = animationXml.@id;
			time = animationXml.@time;
			
			if (animationXml.hasOwnProperty("@curve_type"))
			{
				switch (animationXml.@curve_type.toString())
				{
					case	"instant":
						curveType = INSTANT;
						break;
					case	"linear":
						curveType = LINEAR;
						break;
					case	"quadratic":
						curveType = QUADRATIC;
						break;
					case	"cubic":
						curveType = CUBIC;
						break;
				}
			}

			for each(var boneRefXml:XML in animationXml.bone_ref)
			{				
				var	boneRef:Ref = new Ref ();
				boneRef.parseXML (boneRefXml);
				
				boneRefs.push (boneRef);
			}

			for each(var objectRefXml:XML in animationXml.object_ref)
			{				
				var	objectRef:Ref = new Ref ();
				objectRef.parseXML (objectRefXml);
				
				objectRefs.push (objectRef);
			}
		}

		public	function parse (spriteAnim:SpriterAnimation, animationData:*):void
		{
			id = animationData.id;
			time = animationData.time;
			
			if (animationData.hasOwnProperty ("curve_type"))
			{
				switch (animationData.curve_type)
				{
					case	"instant":
						curveType = INSTANT;
						break;
					case	"linear":
						curveType = LINEAR;
						break;
					case	"quadratic":
						curveType = QUADRATIC;
						break;
					case	"cubic":
						curveType = CUBIC;
						break;
				}
			}

			for each(var boneRefData:* in animationData.bone_ref)
			{				
				var	boneRef:Ref = new Ref ();
				boneRef.parse (boneRefData);
				
				boneRefs.push (boneRef);
			}
			
			for each(var objectRefData:* in animationData.object_ref)
			{				
				var	objectRef:Ref = new Ref ();
				objectRef.parse (objectRefData);
				
				objectRefs.push (objectRef);
			}
		}
	}
}