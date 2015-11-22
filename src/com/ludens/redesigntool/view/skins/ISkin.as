package com.ludens.redesigntool.view.skins
{
	import mx.core.IUIComponent;
	
	public interface ISkin extends IUIComponent
	{
		function set data(value:Object):void;
		function get data():Object;
	}
}