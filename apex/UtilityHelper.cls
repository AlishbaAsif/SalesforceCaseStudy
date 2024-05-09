/*
 * @Author : Alishba
 * @date : 6/May/2024
 * @description : UtilityHelper provides methods to retrieve and process contact and product data
 */
public class UtilityHelper {
    /* 
     * @description : Get contact details based on the UUID
     * @param contactUUId
     * @return list<Contact> to avoid null pointer exception
     */ 
    public static list<Contact> getContactInfo(String contactUUId){
        return [SELECT Id, Product__r.Name, Product__c, Home_Country__c
                FROM Contact
                WHERE UUID__c =: contactUUId]; 
    }
    
    /* 
     * @description : Retrieve product information based on product ID and country
     * @param productId
     * @param homeCountry
     * @return list<ProductData>
     */ 
    public static list<ProductData> getProductInformationForContact(String productId, String homeCountry){
        list<ProductData> productDataList = new list<ProductData>();
        list<PricebookEntry> pricebookEntryList = new list<PricebookEntry>();
        pricebookEntryList = [SELECT Id, Name, UnitPrice, ATM_Surcharge__c, IsAtmSurcharged__c 
                              FROM PricebookEntry
                              WHERE Product2.SourceProductId =: productId
                              AND   Pricebook2.Name =: homeCountry
                              ORDER BY Name];
        if(!pricebookEntryList.isEmpty()){
            productDataList = processPricebookEntries(pricebookEntryList);
        }
        return productDataList;
    }
    
	/* 
     * @description : Convert a list of PricebookEntries into ProductData records list
     * @param pricebookEntryList
     * @return list<ProductData>
     */ 
    private static list<ProductData> processPricebookEntries(list<PricebookEntry> pricebookEntryList){
        list<ProductData> productsDataList = new list<ProductData>();
        for(PricebookEntry ep : pricebookEntryList){
            productsDataList.add(new ProductData(ep.Name, ep.IsAtmSurcharged__c ? String.valueOf(ep.ATM_Surcharge__c) + '%' : String.valueOf(ep.UnitPrice)));
        }
        return productsDataList;
    }
    
    /*
     * @description : class for encapsulating product name and price 
     */
    public class ProductData{
        @AuraEnabled public String productName;
        @AuraEnabled public String price;
       /*
        * @description : Parameterised constructor
        * @param productName
        * @param price
        */
        public ProductData(String productName, String price){
            this.productName = productName;
            this.price = price;
        }
    }
}
