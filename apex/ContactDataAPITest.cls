/*
 * Author : Alishba
 * Date : 08/May/2024
 * @description : Testclass for ContactDataAPI
 */
@isTest 
private class ContactDataAPITest {
    
   /*
    * @description : method to create static data
    */
    @testsetup
    static void createData(){
        Product2 parentProduct = TestDataFactory.createProduct('Standard', 'EUR', 'Base', null, null);
        System.debug(parentProduct);
        Contact cont =  TestDataFactory.createContact(parentProduct.Id, 'DE');
        Case cse = TestDataFactory.createCase(cont.Id);
        Product2 childProduct = TestDataFactory.createProduct('Card Replacement Cost', 'EUR', null, 'Standard', parentProduct.Id);
        PriceBookEntry pbe = TestDataFactory.createPriceBookEntry(Test.getStandardPricebookId(), childProduct.Id, false);
        PriceBook2 pb = TestDataFactory.createPriceBook('DE', 'EUR');
        PriceBookEntry customPbe = TestDataFactory.createPriceBookEntry(pb.Id, childProduct.Id, false);
    }
    
    @isTest
    static void doPostTest() {
        Contact cnt = [SELECT Id, UUID__c FROM Contact LIMIT 1];
        ContactDataAPI.Request request = new ContactDataAPI.Request();
        request.uuId = cnt.UUID__c;
        Test.startTest();
        ContactDataAPI.Response response = ContactDataAPI.doPost(request);
        Test.stopTest();

        // Assertions to verify the API response
        System.assertEquals('Success', response.status, 'Expected status to be "Success"');
        System.assert(response.childProductList != null, 'Expected child product list to be not null');
        System.assertEquals(1, response.childProductList.size(), 'Expected one child product in the list');
    }
    
    @isTest
    static void doPostTestWithEmptyUUId() {
        ContactDataAPI.Request request = new ContactDataAPI.Request();
        request.uuId = '';
        Test.startTest();
        ContactDataAPI.Response response = ContactDataAPI.doPost(request);
        Test.stopTest();

       // Assertions to verify the API response
        System.assertEquals('Failed', response.status, 'Expected status to be "Failed"');
        System.assert(response.childProductList == null, 'Expected child product list to be null');
    }
    
    @isTest
    static void doPostTestWithWrongUUId() {
        ContactDataAPI.Request request = new ContactDataAPI.Request();
        request.uuId = '666555';
        Test.startTest();
        ContactDataAPI.Response response = ContactDataAPI.doPost(request);
        Test.stopTest();

        // Assertions to verify the API response
        System.assert(response.productName == null, 'Expected product to be null');
        System.assert(response.message != null, 'Expected message to be not null');
    }

}
