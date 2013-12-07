package com.acemobe.spriter.data
{
	import com.acemobe.spriter.SpriterAnimation;

	public class MapInstruction
	{
		public	var	folder:int = 0;
		public	var	file:int = 0;
		public	var	tarFolder:int = -1;
		public	var	tarFile:int = -1;
		
		public function MapInstruction()
		{
		}

		public	function parse (spriteAnim:SpriterAnimation, mapInstructionXml:XML):void
		{
			if (mapInstructionXml.hasOwnProperty("@folder"))
				folder = mapInstructionXml.@folder;
			if (mapInstructionXml.hasOwnProperty("@file"))
				file = mapInstructionXml.@file;
			if (mapInstructionXml.hasOwnProperty("@tarFolder"))
				tarFolder = mapInstructionXml.@tarFolder;
			if (mapInstructionXml.hasOwnProperty("@tarFile"))
				tarFile = mapInstructionXml.@tarFile;
		}
	}
}