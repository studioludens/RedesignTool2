package com.ludens.redesigntool.model.om
{
	public class Graphic extends SketchItem
	{
		public var url:String;
		public var title:String;	// optional
		
		public function Graphic(data:Object = null)
		{
			super(data);
			
			if(data){
				if(data.url is String)
					url = data.url;
				
				if(data.title is String)
					title = data.title;
			}
		}
		
	}
}