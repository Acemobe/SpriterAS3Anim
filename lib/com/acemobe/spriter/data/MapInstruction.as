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

		public	function parseXML (spriteAnim:SpriterAnimation, mapInstructionXml:XML):void
		{
			folder = mapInstructionXml.@folder;
			file = mapInstructionXml.@file;

			if (mapInstructionXml.hasOwnProperty("@tarFolder"))
				tarFolder = mapInstructionXml.@tarFolder;
			if (mapInstructionXml.hasOwnProperty("@tarFile"))
				tarFile = mapInstructionXml.@tarFile;
		}

		public	function parse (spriteAnim:SpriterAnimation, mapInstructionData:*):void
		{
			folder = mapInstructionData.folder;
			file = mapInstructionData.file;
			
			if (mapInstructionData.hasOwnProperty("tarFolder"))
				tarFolder = mapInstructionData.tarFolder;
			if (mapInstructionData.hasOwnProperty("tarFile"))
				tarFile = mapInstructionData.tarFile;
		}
	}
}