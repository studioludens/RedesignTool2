package com.ludens.redesigntool.view.components.editor.drawingitem
{
	import com.ludens.redesigntool.controller.Notifications;
	import com.ludens.redesigntool.events.ModelUpdateEvent;
	import com.ludens.redesigntool.events.PropertyUpdateEvent;
	import com.ludens.redesigntool.model.DrawingSettingsProxy;
	import com.ludens.redesigntool.model.om.DrawingItem;
	import com.ludens.redesigntool.model.om.DrawingSettings;
	import com.ludens.redesigntool.model.om.SketchItem;
	import com.ludens.redesigntool.view.components.editor.SketchItemMediator;
	import com.ludens.utilities.PointUtil;
	
	import flash.net.registerClassAlias;
	
	import mx.utils.ObjectUtil;
	
	import org.puremvc.as3.interfaces.*;

	/**
	 * Mediator for the CommentView
	 */
	public class DrawingItemMediator extends SketchItemMediator implements IMediator
	{
		public static const NAME:String = "DrawingItemMediator";
		
		// viewComponent
		private var drawingItemView:DrawingItemView;
		
		//--------------------------------------------------------------------------
		//
		// 	Constructor
		//
	    //--------------------------------------------------------------------------
		
		public function DrawingItemMediator(viewComponent:Object=null)
		{
			drawingItemView = (viewComponent as DrawingItemView);
			
			super(null, viewComponent);
			
			var drawingSettingsProxy:DrawingSettingsProxy = facade.retrieveProxy( DrawingSettingsProxy.NAME ) as DrawingSettingsProxy;
			var drawingSettings:DrawingSettings = drawingSettingsProxy.drawingSettings;
			
			drawingItemView.drawingSettings = drawingSettings;
			
			view.addEventListener( PropertyUpdateEvent.UPDATE, propertyUpdateHandler );
			
			// for ObjectUtil object casting
			registerClassAlias("com.ludens.redesigntool.model.om.DrawingItem", DrawingItem);
		}
		
		//--------------------------------------------------------------------------
	    //
	   	//  Public  methods
	  	//
		//--------------------------------------------------------------------------
		
		/**
		 * Gets view component.
		 */
		override public function getViewComponent():Object
		{
			return viewComponent;
		}

		/**
		 * Returns a list of notifications the CommentMediator is interested in.
		 */
		override public function listNotificationInterests():Array
		{
			var interests:Array = super.listNotificationInterests();
			interests.push( Notifications.DRAWING_ITEMS_EDITED, 
							Notifications.SCALE_RATIO_CHANGED,
							Notifications.DRAWING_SETTINGS_CHANGED );
			
			return interests;
		}
		
		/**
		 * This function is called when a notification is sent to it
		 */
		override public function handleNotification(note:INotification):void
		{	
			switch (note.getName()) {
				
				// if notification is EDIT_ITEMS notification
				case Notifications.ITEMS_EDITED:
					// get data objects array from notification
					var dataArray	:Array = (note.getBody() as Array);
					// get data object from array with corresponding ID 
					var data:Object = getDataWithMatchingId( dataArray );
					// if a data object was found...
					if( data != null )
						// ... set commentView data to match it
						view.data = data;
					break;
				
				// if notification is EDIT_COMMENT notification
				case Notifications.DRAWING_ITEMS_EDITED:
					// get data objects array from notification
					var drawingDataArray	:Array = (note.getBody() as Array);
					// get data object from array with corresponding ID 
					var drawingData:Object = getDataWithMatchingId( drawingDataArray );
					// if a data object was found...
					if( data != null ) {
						// ... set commentView data to match it
						view.data = getDenormalizedData( );
					}
					break;
					
				// if scale ratio changed
				case Notifications.SCALE_RATIO_CHANGED:
					_scaleRatio = note.getBody() as Number;
					view.data = getDenormalizedData( );
					break;
					
				case Notifications.DRAWING_SETTINGS_CHANGED:
					drawingItemView.drawingSettings = note.getBody() as DrawingSettings;
					break;
				
				default:
					super.handleNotification(note);
			}
		}
		
		protected function propertyUpdateHandler( event:PropertyUpdateEvent ):void {
			
			if( event.propertyName == "selectionRange" ) {
				
				var proxy:DrawingSettingsProxy = facade.retrieveProxy( DrawingSettingsProxy.NAME ) as DrawingSettingsProxy;
				var newSelectionRangeproxy:Number =  proxy.drawingSettings.selectionRange + event.newValue;
				
				sendNotification( Notifications.CHANGE_DRAWING_SETTINGS, [ { propertyName: event.propertyName,
																			 newValue: newSelectionRangeproxy } ] );
				view.invalidateDisplayList();
			}
		}
		
		
		override protected function modelUpdateHandler(event:ModelUpdateEvent):void {
			
			// normalize data points
			var dataCopy:DrawingItem = ObjectUtil.copy( event.data ) as DrawingItem;
			dataCopy.dataPoints = PointUtil.normalizePoints( dataCopy.dataPoints, _scaleRatio );
			event.data = dataCopy;
			
			// super the function with normalized points
			super.modelUpdateHandler( event );
		}
		
		override protected function getDenormalizedData( ):SketchItem {
			
			var denormData:DrawingItem = super.getDenormalizedData() as DrawingItem;
			denormData.dataPoints = PointUtil.denormalizePoints( denormData.dataPoints, _scaleRatio );
			
			return denormData;
		}
	}
}