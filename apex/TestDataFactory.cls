/*
 * Author : Alishba
 * Date : 08/May/2024
 * @description Test Data Factory to create data for test classes
 */
@isTest
public class TestDataFactory {
    
   /*
    * @description : To insert Contact
    * @return Contact
    */
    public static Contact createContact(String productId, String country){
        Contact cnt = new Contact(FirstName = 'Mark', 
                                  LastName = 'Smith', 
                                  Email = 'mark@test.com', 
                                  MobilePhone = '+4497867679', 
                                  UUID__c = '12345',
                                  Product__c = productId,
                                  Home_Country__c = country);
        insert cnt;
        return cnt;
    }
    
   /*
    * @description : To insert Case
    * @return Case
    */
    public static Case createCase(String contactId){
        Case cse = new Case(Status = 'New', 
                            Origin = 'Email', 
                            Subject = 'testing subject', 
                            Description = 'testing',
                            ContactId = contactId);
        insert cse;
        return cse;
    }

   /*
    * @description : To insert Product
    */
    public static Product2 createProduct(String productName, String productCurrency, String productType, String productFamily, String sourceProduct){
        Product2 prd =  new Product2(Name = productName,
                                     IsActive = true,
                                     CurrencyIsoCode = productCurrency,
                                     Type = productType,
                                     Family = productFamily,
                                     SourceProductId = sourceProduct,
                                     Description = 'Testing');
        insert prd;
        return prd;
    }

   /*
    * @description : to insert Price Book Entry 
    * @param priceBookId
    * @param productId
    * @param useStandardPrice
    * @return PricebookEntry
    */
    public static PricebookEntry createPriceBookEntry(String priceBookId, String productId, Boolean useStandardPrice){
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = priceBookId,
                                                Product2Id = productId,
                                                UnitPrice = 10.00,
                                                IsActive = true,
                                                UseStandardPrice = useStandardPrice);
        insert pbe;
        return pbe;
    }
    
    /*
    * @description : to insert Custom Price Book 
    * @param priceBookName
    * @param priceBookCurrency
    * @return PriceBook2
    */
    public static PriceBook2 createPriceBook(String priceBookName, String priceBookCurrency){
        PriceBook2 pb = new PriceBook2(Name = priceBookName,
                                       CurrencyIsoCode = priceBookCurrency,
                                       IsActive = true);
        insert pb;
        return pb;
    }

}
