package com.acemobe.spriter.data
{
	public class Folder
	{
		public	var		name:String = "";
		public	var		id:int = 0;
		public	var		files:Array = []; // <file> tags
		
		public function Folder()
		{
		}
		
		public	function parse (folderXml:XML):void
		{
			id = folderXml.@id;
			
			for each(var file:XML in folderXml.file)
			{
				var	f:File = new File ();
				f.parse (file);
				
				files.push (f);
			}
		}
	}
}