package com.ludens.redesigntool.model
{
	import com.ludens.redesigntool.controller.Notifications;
	import com.ludens.redesigntool.model.om.*;
	import com.ludens.utilities.StringUtil;
	
	import flash.display.Bitmap;
	import flash.external.ExternalInterface;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.PNGEncoder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.utils.Base64Encoder;
	import mx.utils.ObjectUtil;
	import mx.utils.UIDUtil;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	/**
	 * RedesignProxy Class
	 * 	implements the interface to the Redesign Model class
	 * 
	 * sends the following notifications:
	 * - DATA_LOADED
	 * - ITEM_EDITED
	 * - ITEMS_EDITED
	 * - ITEM_ADDED
	 * - ITEMS_DELETED
	 * - ITEMS_EDITED
	 * 
	 */
	public class RedesignProxy extends Proxy implements IProxy
	{
		// the proxy name for use in PureMVC
		public static const NAME:String = "RedesignProxy";
		
		private var _redesign:Redesign;
		
		private var _serverConnection:HTTPService;
		
		//--------------------------------------------------------------------------
		//
		// 	Constructor
		//
	    //--------------------------------------------------------------------------
		
		public function RedesignProxy(proxyName:String=null, data:Object=null)
		{
			super( NAME, data );
			
			if(data is Redesign) {
					
				// create a deep copy of the redesign object
				_redesign = ObjectUtil.copy( data ) as Redesign; 
			} else {
				// create new redesign object
				_redesign = new Redesign();
			}
		}
		
		
		//--------------------------------------------------------------------------
	    //
	   	//  Public  methods
	  	//
		//--------------------------------------------------------------------------
		
		/**
		 * save the redesign to the server
		 * 
		 * <p>Let the system know if we have saved the data succesfully</p>
		 */
		public function save():void {
			
			trace("[P] Redesign : saving Redesign...");
		}
		
		public function saveBitmap(bmp:Bitmap):void {
			
			trace("[P] Redesign: saving Redesign bitmap...");
			
			var encoder:PNGEncoder = new PNGEncoder();
			var rawData:ByteArray = encoder.encode(bmp.bitmapData);
			
			var imageDataEnc:Base64Encoder = new Base64Encoder();
	        imageDataEnc.encodeBytes(rawData);
	                	
            var encData:String = imageDataEnc.flush();
			
			// get some settings from the appsettings proxy class
			var appSettingsProxy:AppSettingsProxy = facade.retrieveProxy( AppSettingsProxy.NAME ) as AppSettingsProxy;
			
			trace("[P] Redesign: saving Redesign bitmap to : " + AppSettingsProxy.REDESIGN_SAVE_PATH);
			
			_serverConnection = new HTTPService();
			_serverConnection.url = AppSettingsProxy.REDESIGN_SAVE_PATH;
			_serverConnection.method = "POST";
			_serverConnection.addEventListener( ResultEvent.RESULT, saveResultHandler);
			_serverConnection.addEventListener(FaultEvent.FAULT, saveFaultHandler);
			_serverConnection.send( { 
										imageData: 		encData, 
										id: 			UIDUtil.createUID(),
										session_id:		appSettingsProxy.sessionId,
										path:			appSettingsProxy.path,
										ixItem:			appSettingsProxy.ixItem,
										imgIndex:		appSettingsProxy.imgIndex
									} );
			
		}
		
		/**
		 * load the redesign from the server
		 */
		public function load(id:String):void {
			
			trace("[P] Redesign : loading Redesign...");
			
			if(id){
				// if we have an id, load the item from the server with it
				
				// and let the delegate call the result function of this proxy
			}
		}
		
		// this is called when the delegate receives a result from the service
		public function result( rpcEvent : Object ) : void
		{
			trace("[P] Redesign : processing load result...");
			// call the helper class for parse the XML data
			
			// do something with the data.
			//XmlResource.parse(data, rpcEvent.result);
			
			// call the StartupMonitorProxy for notify that the resource is loaded
			
			this.sendNotification( Notifications.DATA_LOADED );
		}
		
		
		/**
		 * @returns the Redesign Value Object 
		 */
		public function getRedesign():Redesign {
			
			return _redesign;
			
		}
		
		/**
		 * @param id the id of the object to be retrieved
		 * @returns 
		 */
		public function getSketchItem( id:String ):SketchItem {
			
			if (!id) return null;
			
			// find the item in the array with the specified id
			for each(var sketchItem:SketchItem in _redesign.sketchItems ){
				if( sketchItem.id == id ) return sketchItem;
			}
			
			// we have not found anything, return null
			return null;
		}
		
		
		/**
		 * @returns an array of all the comments in the current redesign
		 * 
		 */
		public function getComments():Array {
			
			var commentArray:Array = new Array();
			
			for each(var sketchItem:SketchItem in _redesign.sketchItems){
				
				// check if we have an item of class Comment here. if so, add it to the return array
				if ( sketchItem is Comment) 
					commentArray.push(sketchItem as Comment);
				
			}
			
			return commentArray;
			
		}
		
		/**
		 * this sets a sketch item with a specific id to a new value
		 * <p>If we haven't found the item with the id in the array, return
		 * this with the notification.</p>
		 */
		public function setSketchItem( id:String, sketchItem:SketchItem ):void{
			
			//trace(sketchItem);
			
			var itemFound:Boolean = false;
			// find the item in the array with the specified id
			for each(var item:SketchItem in _redesign.sketchItems ){
				if( item.id == id ){
					itemFound = true;
					item = sketchItem; // does it work like this?
				}
			}
			
			// send a notification for all you listeners out there
			sendNotification(Notifications.ITEM_EDITED, { itemFound:itemFound, sketchItem: sketchItem });
		}
		
		/**
		 * @returns an array of all the drawing items in the current redesign
		 * 
		 */
		public function getDrawingItems():Array {
			
			var drawingItemArray:Array = new Array();
			
			for each(var sketchItem:SketchItem in _redesign.sketchItems){
				
				// check if we have an item of class drawingitem here. if so, add it to the return array
				if ( sketchItem is DrawingItem) 
					drawingItemArray.push(sketchItem as DrawingItem);
				
			}
			
			return drawingItemArray;
			
		}
		
		/**
		 * @returns an array of all the graphics in the current redesign
		 * 
		 */
		public function getGraphics():Array {
			
			var graphicArray:Array = new Array();
			
			for each(var sketchItem:SketchItem in _redesign.sketchItems){
				
				// check if we have an item of class Graphic here. if so, add it to the return array
				if ( sketchItem is Graphic) 
					graphicArray.push( sketchItem as Graphic );
				
			}
			
			return graphicArray;
			
		}
		
		/**
		 * adds a sketch item to the sketch item array
		 */
		public function addSketchItemByClass( modelClass:Class, itemData:Object = null ):SketchItem {
			
			var newItem:SketchItem;
			
			if(itemData)
				newItem = new modelClass( itemData );
			else
				newItem = new modelClass( );
				
			_redesign.sketchItems.push( newItem );
			
			//trace("[P] Redesign added item: ");
			
			// send a notification with the new sketchitem in it
			sendNotification(Notifications.ITEM_ADDED, { sketchItem: newItem } );
			
			return newItem;
		}
		
		/**
		 * parameter ids is an array of strings with id's odf items to be deleted
		 */
		public function deleteSketchItemsById( ids:Array ):void{
			
			var itemsDeleted:Array = new Array();
			
			// loop through the SketchItems and delete the one with the right id
			for(var i:int = _redesign.sketchItems.length - 1; i >= 0; i--){
					
				if ( StringUtil.inArray(_redesign.sketchItems[i].id, ids)){
					// delete the one
					itemsDeleted.push(_redesign.sketchItems[i].id);
					_redesign.sketchItems.splice(i, 1);		
				} 
			}
			
			/*
			trace( "[P] Redesign: deleted items (ID):");
			for each( var item:String in itemsDeleted )
				trace( "    " + item );
			*/
			// send a notification that we have deleted the item with id
			sendNotification(Notifications.ITEMS_DELETED, { itemsDeleted: itemsDeleted } );
		}
		
		public function updateSketchItemsById( ids:Array, newProperties:Object):void {
			
			// loop through all selected items and update the values of those items
			
			// will be an array of all SketchItems that have been edited
			var editedItems:Array = new Array();
			
			for each(var selectedItemID:String in ids){
				// get a reference to the specified sketch item
				var selectedSketchItem:SketchItem = getSketchItem(selectedItemID);
				for( var propertyID:* in newProperties){
					// try to apply the property to the selectedSketchItem
					// should we check for errors?
					selectedSketchItem[propertyID] = newProperties[propertyID];
				}
				
				// push the new sketch item in the return array
				editedItems.push(selectedSketchItem);
			}
			
			// give an ITEMS_EDITED command with the model of all the items that have been
			// edited
			sendNotification(Notifications.ITEMS_EDITED, { itemsEdited: editedItems } );
		}
		
		/**
		 * EVENT HANDLERS
		 */
		 
		private function saveResultHandler( e:ResultEvent ):void{
			trace("[P] Redesign : We have saved the image to the server!");
			
			// call a javascript function to do the redirect
			if(ExternalInterface.available){
				ExternalInterface.call("saveHandler");
			}
		}
		
		private function saveFaultHandler( e:FaultEvent ):void {
			trace("[P] Redesign : something went wrong trying to save the image to the server!:");
		}
		
	}
}