package com.ludens.redesigntool.model
{
	import com.ludens.redesigntool.controller.Notifications;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class SelectionProxy extends Proxy implements IProxy
	{
		// the proxy name for use in PureMVC
		public static const NAME:String = "SelectionProxy";
		
		//--------------------------------------------------------------------------
		//
		// 	Private Properties
		//
		//--------------------------------------------------------------------------	
		
		private var _selectedItems:Array = new Array();
		
		//--------------------------------------------------------------------------
		//
		// 	Constructor
		//
	    //--------------------------------------------------------------------------
		public function SelectionProxy( proxyName:String=null, data:Object=null )
		{
			//TODO: implement function
			super(NAME, data);
		}
		
		public function set selectedItems(value:Array):void {
		
			if( _selectedItems != value ) {
				_selectedItems = value;		
			}
		}
		
		public function get selectedItems():Array {
			return _selectedItems;
		}
		
		//--------------------------------------------------------------------------
	    //
	   	//  Public methods
	  	//
		//--------------------------------------------------------------------------	
		
		/**
		 * adds an item to the array of selected items
		 * does not add if the item's instance is already in the list
		 */
		public function addSelectedItem(newItem:Object):void {
			
			trace(selectedItems);
			
			// check if the new item is not already in the list
			// if so, do not add it and quit function
			var item:Object;
			for each( item in selectedItems ) {
				if( item == newItem ) {
					trace("item is already in selectedItems array!");
					return;
				}
			}
			// item not yet in list, so add it!		
			selectedItems = selectedItems.concat( [newItem] );
		}
		
		/**
		 * removes an item from the array of selected items
		 */
		public function removeSelectedItem(item:Object):void {
			
			trace("[P] Selection : removing item with id = " + item);
			
			// get index of item-to-be-removed
			var index:uint = selectedItems.indexOf(item);
			
			// temporary array with new list of selected items
			var newSelectedItems:Array = selectedItems.slice(0, index);
			
			if( index < selectedItems.length-1 )
				newSelectedItems = newSelectedItems.concat( selectedItems.slice( index + 1 ) );
				
			// new list of selected items is combination of array item before
			// and after index of item-to-be-removed
			selectedItems = newSelectedItems;
		}
		
		public function removeSelectedItems( items:Array ):void {
			trace("[P] Selection : removing items");
			for each(var item:Object in items){
				removeSelectedItem(item);
			}
		}
		
		
		/**
		 * clears the selected item list
		 */
		public function clearSelectedItems():void {
			selectedItems = [ ];
		}
		
		public function notifyChange():void {
			this.sendNotification( Notifications.SELECTION_EDITED, selectedItems );
		}
	}
}

