package com.ludens.redesigntool.view.components.editor
{
	import com.ludens.redesigntool.controller.Notifications;
	import com.ludens.redesigntool.events.ModelUpdateEvent;
	import com.ludens.redesigntool.events.SelectionEvent;
	import com.ludens.redesigntool.model.AppSettingsProxy;
	import com.ludens.redesigntool.model.KeyboardProxy;
	import com.ludens.redesigntool.model.RedesignProxy;
	import com.ludens.redesigntool.model.om.SketchItem;
	import com.ludens.utilities.StringUtil;
	
	import mx.utils.ObjectUtil;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/**
	 * SketchItemMediator is the base mediator on which the other
	 * mediators for concrete sketch item classes are based
	 */
	public class SketchItemMediator extends Mediator implements IMediator
	{
		//--------------------------------------------------------------------------
	    //
	    //  Class constants
	    //
	    //--------------------------------------------------------------------------
		
		public static const NAME:String = "SketchItemMediator";
		
		
		//--------------------------------------------------------------------------
		//
		// 	Public Properties
		//
		//--------------------------------------------------------------------------
		
		public function get view():SketchItemBaseView {
			return viewComponent as SketchItemBaseView;
		}
		
		
		//--------------------------------------------------------------------------
		//
		// 	Private Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _scaleRatio:Number;
		
		//--------------------------------------------------------------------------
		//
		// 	Constructor
		//
	    //--------------------------------------------------------------------------
		
		public function SketchItemMediator(name:String = null, viewComponent:Object=null)
		{
			//if(!name) name = getMediatorName();
			if(!name) name = NAME + "_" + viewComponent.dataId;
			//trace("[M] " + name);
			
			super(name, viewComponent);
			
			view.addEventListener( ModelUpdateEvent.UPDATE_MODEL, modelUpdateHandler);
			view.addEventListener( SelectionEvent.SELECT, selectionHandler );
			
			// get current scale ratio
			var appSettingsProxy:AppSettingsProxy = facade.retrieveProxy( AppSettingsProxy.NAME ) as AppSettingsProxy;
			_scaleRatio = appSettingsProxy.scaleRatio;
		 
		}
		
		//--------------------------------------------------------------------------
	    //
	   	//  Public  methods
	  	//
		//--------------------------------------------------------------------------
		
		/**
		 * Gets name of mediator.
		 */
		override public function getMediatorName():String {
			return NAME + "_" + view.dataId;
		}
		
		/**
		 * Returns a list of notifications the SketchItemMediator is interested in.
		 */
		override public function listNotificationInterests():Array
		{
			
			var interests:Array = [ Notifications.ITEMS_EDITED,
									Notifications.SCALE_RATIO_CHANGED, 
									Notifications.SELECTION_EDITED ];
			
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
						view.data = getDenormalizedData( );
					break;
					
				// if scale ratio changed
				case Notifications.SCALE_RATIO_CHANGED:
					_scaleRatio = note.getBody() as Number;
					view.data = getDenormalizedData( );
					break;

				case Notifications.SELECTION_EDITED:
					//trace("[M] SketchItem : SELECTION_EDITED  on id = " + view.dataId);
					var selectedItems:Array = note.getBody() as Array;
					// check if our id is in the array, if so, select it, otherwise deselect it
					//trace("[M] SketchItem : testing selection for object: " + view.dataId);
					view.selected = StringUtil.inArray(view.dataId, selectedItems);
					
					break;
			}
		}
		
		//--------------------------------------------------------------------------
	    //
	   	//  Private methods
	  	//
		//--------------------------------------------------------------------------
		
		/**
		 * Returns a data object with an id matching the id of the sketchItem.
		 * Returns a null value if no matching id is found
		 */
		protected function getDataWithMatchingId( dataArray:Array ):Object {
			
			// return null if no items in data objects array
			if( !dataArray || dataArray.length == 0 ) return null;
			
			// check if any data objects' ID matches the ID of the view component	
			// if so, return a copy of that data object		
			for each( var data:Object in dataArray ) {
				
				if(data.id == view.data.id)
					// will copy work for dataPoints array in DrawingItem??
					return ObjectUtil.copy(data);			
			}
			
			// otherwise, return null
			return null;
		}
		
		protected function modelUpdateHandler(event:ModelUpdateEvent):void {
			
			sendNotification( Notifications.EDIT_ITEM, event.data );
		}
		
		/**
		 * denormalizes the values of the data object
		 * and updates the view data property
		 */
		protected function getDenormalizedData( ):SketchItem {
			
			var redesignProxy:RedesignProxy = facade.retrieveProxy( RedesignProxy.NAME ) as RedesignProxy;
			var normData:SketchItem = redesignProxy.getSketchItem( view.dataId ) as SketchItem;
			
			var denormData:SketchItem = new SketchItem();
			denormData.x 		= normData.x * _scaleRatio;
			denormData.y 		= normData.y * _scaleRatio;
			denormData.width 	= normData.width * _scaleRatio;
			denormData.height 	= normData.height * _scaleRatio;
			
			return denormData;
		}
		
		
		
		protected function selectionHandler( event:SelectionEvent):void {
			
			//trace("[M] SketchItem : selectionHandler  at id = " + event.id );
			
			// see if the shift key is pressed, if so, add, don't clear
			
			var keyboardProxy:KeyboardProxy = facade.retrieveProxy( KeyboardProxy.NAME ) as KeyboardProxy;
			//trace("[M] SketchItem: ADDING : " + keyboardProxy.shiftKey );
			
			sendNotification( Notifications.EDIT_SELECTION, { clear: ! keyboardProxy.shiftKey , addItems: [ event.id ] });
		}
	}
}