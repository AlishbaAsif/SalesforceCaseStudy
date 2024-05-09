/*
 * @Author : Alishba
 * @date : 6/May/2024
 * @description : Controller for CustomerProductLwc, it retrieves customer product information to display on the Case Lightning Record Page
 */
public class CustomerProductLwcController {

	  /*
	   * @description : Retrieve the product information for the contact associated with a case
     * @param caseId
     * @return ProductInfo object containing the product name and a list of child product data
     */    
    @AuraEnabled
    public static ProductInfo getProductInfo(String caseId){
        list<PricebookEntry> pricebookEntryList = new list<PricebookEntry>();
        ProductInfo proInfo;

        //SOQL: Retrieve the Contact UUID associated with the given Case record
        String contactUUId = [SELECT Id, Contact.UUID__c
                              FROM Case
                              WHERE Id =: caseId].Contact.UUID__c;
        
        if(contactUUId != null){
            //Use UtilityHelper method to fetch Case Contact record
            list<Contact> contactRecordList = UtilityHelper.getContactInfo(contactUUId);
            
            if(!String.isBlank(contactRecordList[0].Product__c) && !String.isBlank(contactRecordList[0].Home_Country__c)){
                //Use UtilityHelper method to fetch the product information based on the contact's product and country
                proInfo = new ProductInfo(contactRecordList[0].Product__r.Name, UtilityHelper.getProductInformationForContact(contactRecordList[0].Product__c , contactRecordList[0].Home_Country__c));            
            }
        }
        return proInfo;
    }
    
    /*
     * @description : Wrapper class to encapsulate related data i.e. product information, including child product data.
     */
    public class ProductInfo{
        @AuraEnabled public String productName;
        @AuraEnabled public list<UtilityHelper.ProductData> childProductList;
       /*
        * @description : Parameterised constructor
        * @param productName
        * @param childProductList
        */
        public ProductInfo(String productName, list<UtilityHelper.ProductData> childProductList){
            this.productName = productName;
            this.childProductList = childProductList;
        }
    }
}
