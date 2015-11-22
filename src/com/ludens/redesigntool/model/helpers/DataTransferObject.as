package com.ludens.redesigntool.model.helpers
{
	/**
	 * The DataTransferObject implements a simple method to communicate with a webserver using AMF.
	 * 
	 * @author ludens
	 * 
	 */	
	public class DataTransferObject implements IXMLExportable
	{
		public function DataTransferObject()
		{
		}
		
		/**
		 * the toXML function gets all the public properties of this object and generates XML from it.
		 * 
		 */
		public function toXML():XML
		{
			return new XML();
		}
		
		/**
		 * the load() function loads an object from the server using AMF
		 * 
		 * @param c The criteria for selecting the object
		 * 
		 * @return returns true if we are succesfull in loading the object from the server
		 * 
		 */
		public function load(c:Object):Boolean {
			
			// TODO: implement function
			
			return true;
		}
		
		
		/**
		 * the save() function saves an object to the server using AMF
		 * 
		 * @return returns true if we are succesfull in saving the object to the server
		 * 
		 * <p>This function generates an event when it is done saving. </p>
		 * 
		 */
		public function save(callbackFunction:Function):Boolean {
			// TODO: implement function
			
			return true;
		}
		
	}
}