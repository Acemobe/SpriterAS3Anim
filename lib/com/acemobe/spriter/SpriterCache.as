package com.acemobe.spriter
{
	import flash.utils.Dictionary;

	public class SpriterCache
	{
		private	static	var	mAnimations:Dictionary = new Dictionary;
		
		public function SpriterCache()
		{
		}
		
		public	static	function findAnimation (name:String):SpriterAnimation
		{
			return mAnimations[name];
		}

		public	static	function addAnimation (name:String, anim:SpriterAnimation):SpriterAnimation
		{
			mAnimations[name] = anim;
			
			return anim;
		}
	}
}