package com.ludens.redesigntool.view.components.editor
{
	import com.ludens.redesigntool.view.skins.SkinUtil;
	
	public class GraphicView extends SketchItemBaseView
	{
		
		public function GraphicView()
		{
			super();
			
			
			_skinType = SkinUtil.GRAPHIC_TYPE;
			verticalScrollPolicy = "off";
		}
		
	}
}