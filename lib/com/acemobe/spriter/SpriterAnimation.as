package com.acemobe.spriter
{
	import com.acemobe.spriter.data.SpriterXML;
	
	import starling.textures.TextureAtlas;

	public class SpriterAnimation
	{
		public	var	folders:Array = [];
		public	var	entities:Array = []; // <entity> tags  
		public	var	activeCharacterMap:Array = [];
		public	var	atlas:TextureAtlas;
		
		public function SpriterAnimation(data:XML, atlas:TextureAtlas)
		{
			this.atlas = atlas;
			SpriterXML.parse (this, data);
		}
	}
}