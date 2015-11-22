package com.ludens.redesigntool.controller.commands
{
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/* IS THIS COMMAND ANY GOOD, MAYBE WE CAN DO WITH A MORE GENERAL COMMAND ?? */
	
	public class EditCommentsCommand extends SimpleCommand implements ICommand
	{
		private var _commentIDs		:Array;
		private var _propertyName	:String;
		private var _propertyValue	:Object;
		
		public function EditCommentsCommand( commentIDs:Array propertyName:String, propertyValue:Object )
		{
			super();
			
			_commentIDs 	= commentIDs;
			_propertyName 	= propertyName;
			_propertyValue 	= propertyValue;
		}
		
		/**
		 * execute the EditComments Command
		 * 
		 * <p>For now, just display a status message</p>
		 * 
		 */
		override public function execute(notification:INotification):void
		{
			trace(">> edit comments >>");
			
			// add an item in the proxy
			
		}

	}
}