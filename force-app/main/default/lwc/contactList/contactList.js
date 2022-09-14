import { LightningElement,api,track } from 'lwc';

import {CloseActionScreenEvent } from 'lightning/actions';
import contactSearch from '@salesforce/apex/AccountController.getAccountsOnSearch'

import CONTACT_OBJECT from "@salesforce/schema/Contact";



export default class ContactList extends LightningElement {
    key = "";
    @track columns =  [
        { label: 'Name',  fieldName: 'Name', type: 'button',  typeAttributes: { label: { fieldName: 'Name' }, variant: 'base' } },
        { label: 'Email', fieldName: 'Email', type: 'email'},
        { label: 'Phone', fieldName: 'Phone', type: 'phone' },    
    ];

    objectApiName=CONTACT_OBJECT;
    
    @track contactId;
    @track data;
    @track errorMsg;
    @track isShowModal;

    @api recordId;

    IdTag ="";
    ImgTag ="";
    NameTag ="";
    TitleTag ="";
    EmailTag ="";
    PhoneTag ="";

    

    navigateToContactPage(){
        window.location.href = 'https://theksquaregroup-df-dev-ed.develop.lightning.force.com/lightning/r/Contact/'+ this.contactId +'/view';
        }

    async connectedCallback(){
        
        setTimeout(()=>{

            try {
                contactSearch({searchKey:this.key , accId:this.recordId})
                .then(result=>{

                    this.data = result;
                })
                .catch(error=>{
                    console.log("Error: " + error);
                    this.data = null;
                });
        } catch (error) {
            this.error = error;
        }

        },500);
    }



    getContacts({error,data}){
        if(data){
            console.log("Data: "+ JSON.stringify(data));
            this.data = data;
            this.errorMsg = undefined;
        }else{
            
            console.log("Error: "+ JSON.stringify(error));
            this.errorMsg = error;
            this.data = undefined;
        }
        
    };
    
    updateKey(event){
        this.key = event.target.value;
        console.log("key Length: " + this.key.length);
        const length = parseInt(this.key.length);

        if(length >= 3 || length ==0 ){
            console.log("If");
            contactSearch({searchKey:this.key , accId:this.recordId})
            .then(result=>{
                console.log("Result: " + JSON.stringify(result));
                this.data = result;
            })
            .catch(error=>{
                console.log("Error: " + error);
                this.data = null;
            });
        }
        
    }   

    
    
    
    handleSearch(){
        //Call Search method on Controller
        contactSearch({searchKey:this.key , accId:this.recordId})
        .then(result=>{
            console.log("Result: " + JSON.stringify(result));
            this.data = result;
        })
        .catch(error=>{
            console.log("Error: " + error);
            this.data = null;
        });
    }

    handleEnter(event){
        if(event.keyCode === 13){
            this.handleSearch();
        }
    }

    handleRowAction(event){

        const row = event.detail.row;
        this.ImgTag = row.Profile_Picture__c;
        this.NameTag = row.Name;
        this.TitleTag = row.Title;
        this.EmailTag = row.Email;
        this.PhoneTag = row.Phone;
        this.contactId = row.Id;
        
    }

    closeQuickAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    createContactModal(){
        this.isShowModal = true;
    }
    
    hideModalBox(){
        this.isShowModal = false;
    }

}