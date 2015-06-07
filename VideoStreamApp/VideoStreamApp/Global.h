//
//  Global.h
//  iTaxi
//
//  Created by Maxim Guzun on 14/11/14.
//  Copyright SmartData All rights reserved.
//

#ifndef XTrade_Global_h
#define XTrade_Global_h

#define kServer                     @"http://10.0.0.21:3000/api/photo"
#define kWEBSOKET                   @"ws://10.0.0.35:9000"
#define kSessionID                  @"kSessionID"
#define kHeaderCookie               @"Cookie"
#define kCrashlyticsKey             @"bae219119cf13f6fc5dc8da62ef8bc42443c2093"

#define kBlueMain                   0x1c6cae
#define kMenuBackgroundDown         0x1d486d
#define kMenuBackgroundUp           0x156384
#define kMainGrayLight              0xE5E5E5
#define kMainGreen                  0x0e979b
#define kMainBlue                   0x1C6CAE
#define kMainRed                    0x8E2429

#define kMSGLoginOK                 @"kMSGLoginOK"
#define kMGS_NAVBAR                 @"kMGS_NAVBAR"
#define kMSGUpdateComments          @"kMSGUpdateComments"
#define kMSGPostComments            @"kMSGPostComments"
#define kMSGCREATEALBUM             @"kMSGCREATEALBUM"
#define kAccount                    @"kAccount"
#define kMessage                    @"kMessage"
#define kMSG_UPDATE_COMMENTS        @"kMSG_UPDATE_COMMENTS"
#define kSkipper_server             @"skipper_server"
#define kSkipper_user               @"skipper_user"

// BUYER ACTIONS
#define ACTION_ORDER_RECEIVED       @"receivedAction"
#define ACTION_ORDER_CHECKOUT       @"checkOutAction"
#define ACTION_ORDER_TEXT           @"actionsText"
#define ACTION_CHAR_URL             @"chatUrl"

// SELLER ACTIONS
#define ACTION_ORDER_REFUND         @"refundAction"
#define ACTION_ORDER_SHIPPED        @"shippedAction"
#define ACTION_ORDER_TRACK          @"setTrackingNumberAction"
#define ACTION_ORDER_APPOINTMENT    @"setAppointmentAction"

#define kCompression                0.1f
#define kMaxZoom                    12.0f
#define kGranularyTrashold          5


#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define TRANSLATE(key) NSLocalizedString(key, nil)

#define IS_IPHONE ([[[UIDevice currentDevice] model] isEqualToString:@"iPhone"])
#define IS_IPAD ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"])

typedef enum{
    SERVER_STATUS_OK                = 200
}SERVER_STATUS;

typedef enum{
    MENU_ITEM_HOME                  = 0,
    MENU_ITEM_PROFILE               = 1,
    MENU_ITEM_MESSAGES              = 2,
    MENU_ITEM_NOTIFICATIONS         = 3,
    MENU_ITEM_TRADES                = 4,
    MENU_ITEM_SELL_NOW              = 5,
    MENU_ITEM_BUYER                 = 6,
    MENU_ITEM_SELLER                = 7,
    MENU_ITEM_SETTINGS              = 8,
    MENU_ITEM_HELP                  = 9,
    MENU_ITEM_LOGOUT                = 10
}MENU_ITEM;

typedef enum{
    ACTIVITY_TYPE_POST_TO_WALL      = 1,
    ACTIVITY_TYPE_SHARE             = 2,
    ACTIVITY_TYPE_IMAGE_UPLOAD      = 3,
    ACTIVITY_TYPE_SET_PROFILE_IMAGE = 4,
    ACTIVITY_TYPE_ADD_TRADE         = 5,
    ACTIVITY_TYPE_BID_ON_TRADE      = 6,
    ACTIVITY_TYPE_FOLLOW            = 7,
    ACTIVITY_TYPE_LIKE              = 8,
    ACTIVITY_TYPE_COMMENT           = 9,
    ACTIVITY_TYPE_WON_TRADE         = 10,
    ACTIVITY_TYPE_SOLD_TRADE        = 11
}ACTIVITY_TYPE;

typedef enum{
    OBJECT_TYPE_NONE                = 0,
    OBJECT_TYPE_LINK                = 1,
    OBJECT_TYPE_IMAGE               = 2,
    OBJECT_TYPE_WALLPOST            = 3,
    OBJECT_TYPE_TRADE               = 4,
    OBJECT_TYPE_BID                 = 6,
    OBJECT_TYPE_IMAGE_GROUP         = 5,
    OBJECT_TYPE_USER                = 10,
    OBJECT_TYPE_ACTIVITY            = 11,
    OBJECT_TYPE_ORDER               = 12
}OBJECT_TYPE;

typedef enum{
    CMD_ZOOM_IN                     = 1,
    CMD_ZOOM_OUT                    = 2,
    CMD_TORCH_ON                    = 3,
    CMD_TORCH_OFF                   = 4,
    CMD_VIDEO_SEND                  = 5
}CMD;

#endif
