package com.ludens.redesigntool.controller.commands
{
	import com.ludens.redesigntool.model.SelectionProxy;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	

	public class EditSelectionCommand extends SimpleCommand implements ICommand
	{
		public function EditSelectionCommand()
		{
			super();
		}
		
		/**
		 * in the note body, we should get a list of id's of selected items
		 * it looks like this:
		 * 
		 * {
		 * 		addItems: 		[ Array ],
		 * 		removeItems: 	[ Array ],
		 * 		clear:			Boolean
		 * }
		 * 
		 */	
		override public function execute(note:INotification):void
		{
			
			var addItems:Array = note.getBody().addItems as Array;
			var removeItems:Array = note.getBody().removeItems as Array;
			var clear:Boolean = note.getBody().clear as Boolean;
			
			var selectionProxy:SelectionProxy = facade.retrieveProxy( SelectionProxy.NAME ) as SelectionProxy;
			
			if( clear ){
				selectionProxy.clearSelectedItems();
			}
			
			// check what we have
			if(addItems && addItems.length > 0){
				for each( var addItem:String in addItems ){
					selectionProxy.addSelectedItem( addItem );
				}
			}
			
			if(removeItems && removeItems.length > 0){
				for each( var removeItem:String in removeItems ){
					selectionProxy.removeSelectedItem( removeItem );
				}
			}
			
			// return a notification with the list of selected item id's
			selectionProxy.notifyChange();
			
			
			//trace("[C] EditSelection count: " + selectionProxy.selectedItems.length);
			
		}
		
		

	}
}
