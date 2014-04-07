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
		
		public	function parseXML (folderXml:XML):void
		{
			id = folderXml.@id;
			name = folderXml.@name;
			
			for each(var file:XML in folderXml.file)
			{
				var	f:File = new File ();
				f.parseXML (file);
				
				files.push (f);
			}
		}

		public	function parse (folder:*):void
		{
			id = folder.id;
			name = folder.name;
			
			for (var a:int = 0; a  < folder.file.length; a++)
			{
				var	f:File = new File ();
				f.parse (folder.file[a]);
				
				files.push (f);
			}
		}
	}
}