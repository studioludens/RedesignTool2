package com.ludens.redesigntool.controller.commands
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.interfaces.ICommand;
	
	/**
	 * 
	 * @author rulkens
	 * 
	 */
	public class ShutdownCommand extends SimpleCommand implements ICommand
	{
		
		public function ShutdownCommand()
		{
			super();
			
		}
		
		/**
		 * execute the Shutdown Command
		 * 
		 * <p>For now, just display a status message</p>
		 * 
		 */
		override public function execute(notification:INotification):void
		{
			trace(">> Application terminated >>");
		}
		
	}
}