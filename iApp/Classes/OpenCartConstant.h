//
//  OpenCartConstant.h
//  iApp
//
//  Created by icoco7 on 6/22/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenCartConstant : NSObject

    extern  NSString* Rest_json;
    extern  NSString* Rest_status;
    extern  NSString* Rest_data;
    extern  NSString* Rest_success;
    extern  NSString* Rest_error;
    extern  NSString* Rest_warning;

    extern  NSString* _Meta_title;
    extern  NSString* _Meta_text;



    extern  NSString* Product_product_id;
    extern  NSString* Product_name;
    extern  NSString* Product_popup;
    extern  NSString* Product_thumb;
    extern  NSString* Product_images;
    extern  NSString* Product_quantity;

    extern  NSString* Product_Discounts_price;
    extern  NSString* Product_Discounts_quantity;
    extern  NSString* Product_text_discount;

    extern  NSString* Account_success;
    extern  NSString* Account_error_warning;

    extern  NSString* Cart_products;
    extern  NSString* Cart_totals;

    extern  NSString* Cart_Product_name;
    extern  NSString* Cart_Product_model;
    extern  NSString* Cart_Product_name;
    extern  NSString* Cart_Product_price;
    extern  NSString* Cart_Product_quantity;
    extern  NSString* Cart_Product_total;

    extern  NSString* CheckoutPaymentAddress_addresses;
    extern  NSString* CheckoutPaymentAddress_address_id;
    extern  NSString* CheckoutPaymentAddress_payment_address;


    extern  NSString* CheckoutShappingAddress_shipping_address;

    extern  NSString* Checkout_shipping_methods;
    extern  NSString* Checkout_shipping_method;
    extern  NSString* CheckoutShappingMethod_flat;
    extern  NSString* CheckoutShappingMethod_code;



    extern  NSString* CheckoutShippingMethod_title;
    extern  NSString* CheckoutShippingMethod_quote;
    extern  NSString* CheckoutShippingMethod_text;

    extern  NSString* Checkout_payment_methods;
    extern  NSString* Checkout_payment_method;

    extern  NSString* Checkout_comment;
    extern  NSString* Checkout_agree;

    extern  NSString* TRUE_ONE;
@end
