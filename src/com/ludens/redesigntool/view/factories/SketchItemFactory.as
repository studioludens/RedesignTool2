package com.ludens.redesigntool.view.factories
{
	import com.ludens.redesigntool.model.om.Comment;
	import com.ludens.redesigntool.model.om.DrawingItem;
	import com.ludens.redesigntool.model.om.Graphic;
	import com.ludens.redesigntool.model.om.SketchItem;
	import com.ludens.redesigntool.view.components.editor.*;
	import com.ludens.redesigntool.view.components.editor.drawingitem.DrawingItemMediator;
	import com.ludens.redesigntool.view.components.editor.drawingitem.DrawingItemView;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/**
	 * The SketchItemFactory provides functions for generating View Components and
	 * Mediator components
	 */
	public class SketchItemFactory
	{
		/**
		 * default values for the different Sketch Items
		 */
		 
		public static const GRAPHIC_MAX_WIDTH:Number = 600;
		public static const GRAPHIC_MAX_HEIGHT:Number = 400;
		
		public static const DEFAULT_X:Number = 30;
		public static const DEFAULT_Y:Number = 30;
		public static const DEFAULT_WIDTH:Number = 100;
		public static const DEFAULT_HEIGHT:Number = 100;
		
		
		public static const DEFAULT_COMMENT_BOX_X:Number = 100;
		public static const DEFAULT_COMMENT_BOX_Y:Number = 100;
		public static const DEFAULT_COMMENT_BOX_WIDTH:Number = 120;
		public static const DEFAULT_COMMENT_BOX_HEIGHT:Number = 100;
		
		
		public static const DEFAULT_DRAWING_X:Number = 0;
		public static const DEFAULT_DRAWING_Y:Number = 0;
		public static const DEFAULT_DRAWING_LINE_COLOR:Number = 0x000000;
		public static const DEFAULT_DRAWING_FILL_COLOR:Number = 0xCCCCCC;
		
		public static const DEFAULT_GRAPHIC_URL:String = "assets/media/testimg.png";
		public static const DEFAULT_GRAPHIC_TITLE:String = "Test Image";
		
		public function SketchItemFactory()
		{
		}
		
		/**
		 * this function generates a SketchItemView object for the supplied sketchItem, based on the
		 * subclass of the SketchItem
		 */
		public static function createSketchItemView( sketchItem:SketchItem ):SketchItemBaseView {
			
			var newItem:SketchItemBaseView;
			
			// first, determine the class of the sketchitem
			if(sketchItem is Comment){
				newItem = new CommentView();
				
				var comment:Comment = sketchItem as Comment;
				
				comment.x = 		SketchItemFactory.DEFAULT_X;
				comment.y = 		SketchItemFactory.DEFAULT_Y;
				comment.width = 	SketchItemFactory.DEFAULT_WIDTH;
				comment.height = 	SketchItemFactory.DEFAULT_HEIGHT;
				comment.boxX = 		SketchItemFactory.DEFAULT_COMMENT_BOX_X;
				comment.boxY = 		SketchItemFactory.DEFAULT_COMMENT_BOX_Y;
				comment.boxWidth = 	SketchItemFactory.DEFAULT_COMMENT_BOX_WIDTH;
				comment.boxHeight = SketchItemFactory.DEFAULT_COMMENT_BOX_HEIGHT;
				
				newItem.data = 		comment;
				
			} else if(sketchItem is DrawingItem){
				newItem = new DrawingItemView();
				
				var drawingItem:DrawingItem = sketchItem as DrawingItem;
				
				drawingItem.x = 		SketchItemFactory.DEFAULT_DRAWING_X;
				drawingItem.y = 		SketchItemFactory.DEFAULT_DRAWING_Y;
				drawingItem.width = 	SketchItemFactory.DEFAULT_WIDTH;
				drawingItem.height = 	SketchItemFactory.DEFAULT_HEIGHT;
				drawingItem.lineColor = SketchItemFactory.DEFAULT_DRAWING_LINE_COLOR;
				drawingItem.fillColor = SketchItemFactory.DEFAULT_DRAWING_FILL_COLOR;
				
				//drawingItem.dataPoints = [ new Point(0,0), new Point(100,100), new Point( 50,100) ];
				drawingItem.dataPoints = [ ];
				
				newItem.data = 		drawingItem;
				
			} else if(sketchItem is Graphic){
				newItem = new GraphicView();
				
				
				var graphic:Graphic = sketchItem as Graphic;
				
				if(!graphic.x)		graphic.x = 		DEFAULT_X;	
				if(!graphic.y)		graphic.y = 		DEFAULT_Y;
				if(!graphic.width )	graphic.width = 	396;
				if(!graphic.height)	graphic.height = 	396;					
				if(!graphic.url)	graphic.url = 		DEFAULT_GRAPHIC_URL;
				if(!graphic.title)	graphic.title = 	DEFAULT_GRAPHIC_TITLE;
				
				// check for the max width and height
				if(graphic.width > GRAPHIC_MAX_WIDTH || graphic.height > GRAPHIC_MAX_HEIGHT){
					// scale down
					// to fit the max width and height bounding box
					var scaleFactorX:Number = graphic.width / GRAPHIC_MAX_WIDTH;
					var scaleFactorY:Number = graphic.height / GRAPHIC_MAX_HEIGHT;
					
					var scaleFactor:Number = (scaleFactorX > scaleFactorY ? scaleFactorX : scaleFactorY);
					
					graphic.width = graphic.width / scaleFactor;
					graphic.height = graphic.height / scaleFactor;
					
				}
				
				newItem.data = graphic;
				
			} else {
				trace("[SketchItemFactory::view] WARNING: class not recognized! ");
			}
			
			/**
			 * TODO:
			 * - create code for generating the other classes of the model
			 */
			
			// return the view object
			return newItem;
			
		}
		
		public static function createSketchItemMediator( sketchItemView:SketchItemBaseView ):Mediator {
			
			var newMediator:Mediator;
			
			if( sketchItemView is CommentView){
				newMediator = new CommentMediator( sketchItemView );
			} 
			else if( sketchItemView is DrawingItemView){
				newMediator = new DrawingItemMediator( sketchItemView );
			}
			else if( sketchItemView is GraphicView){
				newMediator = new GraphicMediator( sketchItemView );
			}
			else {
				trace("[SketchItemFactory::mediator] WARNING: class not recognized! ");
			}
			
			return newMediator;
		}

	}
}