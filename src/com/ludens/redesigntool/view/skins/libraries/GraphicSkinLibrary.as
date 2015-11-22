package com.ludens.redesigntool.view.skins.libraries
{
	import com.ludens.redesigntool.view.skins.ISkinLibrary;
	import com.ludens.redesigntool.view.skins.drawing.*;
	import com.ludens.redesigntool.view.skins.graphic.*;
	
	public class GraphicSkinLibrary implements ISkinLibrary
	{
		
		private static const DEFAULT_SKIN		:Class = SimpleGraphicSkin;
		
		public static function getSkinByName( skinName:String ):Class {
			
			return GraphicSkinLibrary[skinName];
		}
	}
}