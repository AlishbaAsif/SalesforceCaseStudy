/*
 * Author : Alishba
 * Date : 08/May/2024
 * @description : Testclass for CustomerProductLwcController
 */
@isTest 
private class CustomerProductLwcControllerTest {
    
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
    
    @isTest static void getProductInfoTest() {
        Case cse = [SELECT Id FROM Case LIMIT 1];
        Test.startTest();
        CustomerProductLwcController.ProductInfo productInfo = CustomerProductLwcController.getProductInfo(cse.Id);
        Test.stopTest();

        // Assertions to validate result
        System.assert(productInfo != null, 'Expected a non-null ProductInfo instance');
        System.assertEquals(1, productInfo.childProductList.size(), 'Expected one child product in the list');
    
    }
}
