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
		
		public	function parse (spriteAnim:SpriterAnimation, animationXml:XML):void
		{
			if (animationXml.hasOwnProperty("@id"))
				id = animationXml.@id;
			if (animationXml.hasOwnProperty("@time"))
				time = animationXml.@time;
			
			for each(var boneRefXml:XML in animationXml.bone_ref)
			{				
				var	boneRef:Ref = new Ref ();
				boneRef.parse (boneRefXml);
				
				boneRefs.push (boneRef);
			}

			for each(var objectRefXml:XML in animationXml.object_ref)
			{				
				var	objectRef:Ref = new Ref ();
				objectRef.parse (objectRefXml);
				
				objectRefs.push (objectRef);
			}
		}

	}
}