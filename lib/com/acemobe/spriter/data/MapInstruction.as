package com.acemobe.spriter.data
{
	public class MapInstruction
	{
		public	var	folder:int = 0;
		public	var	file:int = 0;
		public	var	tarFolder:int = -1;
		public	var	tarFile:int = -1;
		
		public function MapInstruction()
		{
		}

		public	function parse (mapInstructionXml:XML):void
		{
			if (mapInstructionXml.attribute("folder").length())
				folder = mapInstructionXml.@folder;
			if (mapInstructionXml.attribute("file").length())
				file = mapInstructionXml.@file;
			if (mapInstructionXml.attribute("tarFolder").length())
				tarFolder = mapInstructionXml.@tarFolder;
			if (mapInstructionXml.attribute("tarFile").length())
				tarFile = mapInstructionXml.@tarFile;
		}
	}
}