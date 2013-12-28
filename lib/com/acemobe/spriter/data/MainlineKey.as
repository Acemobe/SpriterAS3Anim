package com.acemobe.spriter.data
{
	import com.acemobe.spriter.SpriterAnimation;

	public class MainlineKey
	{
		public	var	id:int = 0;
		public	var	time:int = 0;
		public	var	boneRefs:Array = [];
		public	var	objectRefs:Array = [];
		
		public function MainlineKey()
		{
		}
		
		public	function parseXML (spriteAnim:SpriterAnimation, animationXml:XML):void
		{
			id = animationXml.@id;
			time = animationXml.@time;
			
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