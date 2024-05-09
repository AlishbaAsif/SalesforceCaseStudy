/*
 * @author : Alishba 
 * @date : 08/May/2024
 * @description : API for retrieving contact's product information based on UUID
 */
@RestResource(urlMapping='/ContactDataAPI/*')
global class ContactDataAPI {
    
    /*
     * @description Entry point to fetch product information for contact
     * @param request http request
     * @return Response response
     */
    @HttpPost
    global static Response doPost(Request request) {
        Response response = new Response();
        
        if(String.isBlank(request.uuId))
            return new Response('Unique identifier (UUID) missing');
        
        //Use UtilityHelper method to fetch Case Contact record
        list<Contact> contactRecordList = UtilityHelper.getContactInfo(request.uuId);
        if(contactRecordList.isEmpty())
            return new Response('Contact does not exist for UUID: '+request.uuId);
        
        if(String.isBlank(contactRecordList[0].Product__c))
            return new Response('No Product Associated with Contact');
        
        if(!String.isBlank(contactRecordList[0].Product__c) && !String.isBlank(contactRecordList[0].Home_Country__c)){
            response.status = 'Success';
        	response.message = 'Success';
            response.productName = contactRecordList[0].Product__r.Name;
            response.childProductList = UtilityHelper.getProductInformationForContact(contactRecordList[0].Product__c , contactRecordList[0].Home_Country__c);
        }
         
        return response;
    }
    
   /*
	* @description : Request body wrapper class
	*/
    global class Request {
        global String uuId;
    }
    
   /*
	* @description : Response body wrapper class
	*/ 
    global class Response{
        global String status;
        global String message;
        global String productName;
        global List<UtilityHelper.ProductData> childProductList;
        
       /*
        * @description : Response constructor
        */
        global Response(){}
        
       /*
        * @description : Parameterised constructor
        * @param errorMessage
        */
        global Response(String errorMessage){
            this.status = 'Failed';
            this.message = errorMessage;
        }   
    }
}
