package com.acemobe.spriter
{
	import com.acemobe.spriter.parsers.SpriterJSON;
	import com.acemobe.spriter.parsers.SpriterXML;
	
	public class SpriterAnimation
	{
		public	var	name:String = "";
		
		public	var	folders:Array = [];
		public	var	entities:Array = []; // <entity> tags  
		public	var	activeCharacterMap:Array = [];
		
		public function SpriterAnimation(name:String, data:*, entities:Array = null, animations:Array = null)
		{
			this.name = name;
			
			if (data is XML)
				SpriterXML.parse (this, data, entities, animations);
			else 
				SpriterJSON.parse (this, data, entities, animations);
		}
	}
}