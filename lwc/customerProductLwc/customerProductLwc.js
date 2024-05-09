import { LightningElement, api, track } from 'lwc';
import loadComponent from '@salesforce/apex/CustomerProductLwcController.getProductInfo';
export default class CustomerProductLwc extends LightningElement {

    @api recordId;
    @track productInfo = {};
    connectedCallback() {
       this.init();
    }
 
    init() {
       loadComponent({
          'caseId': this.recordId
       }).then(result => {
          console.log('result..!', result);
          this.productInfo = result;
          console.log('productInfo..!', this.productInfo);
       }).catch(error => {
          console.log('error..!', error);
       });
    }
}
