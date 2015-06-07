//
//  OperationProtocol.h
//  WebRadioAPI
//
//  Created by Maxim Guzun on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class JSONModel;
@class ResultItem;
@class BusinessList;
@class AccountData;
@class NotificationsResult;
@class NotificationSettingsResult;
@class OperationResult;
@class InterestsOperationResult;
@protocol OperationProtocol <NSObject>

@optional
- (void)    onGetAccountResult:(AccountData*)pResult status:(NSNumber*)pStatus;
- (void)	onLoginResult:(JSONModel*)pRresult status:(NSNumber*)status;
- (void)	onRegisterResult:(JSONModel*)pResult status:(NSNumber*)status;
- (void)    onConfirmEmailResult:(JSONModel*)pResult status:(NSNumber*)status;
- (void)    onSetPassswordResult:(ResultItem*)pResult status:(NSNumber*)status;
- (void)	onRestorePasswordResult:(ResultItem*)pResult status:(NSNumber*)status;
- (void)    onSignOutResult:(JSONModel*)pResult status:(NSNumber*)status;
- (void)    onNotificationsResult:(NotificationsResult*)pResult status:(NSNumber*)status;
- (void)    onNotificationSettingsResult:(NotificationSettingsResult*)pResult status:(NSNumber*)status;
- (void)    onSetNotificationsResult:(OperationResult*)pResult status:(NSNumber*)status;
- (void)    onGetInterestsResult:(InterestsOperationResult*)pResult status:(NSNumber*)status;
- (void)    onSetInterestsResult:(OperationResult*)pResult status:(NSNumber*)status;
- (void)    onChangePasswordResult:(OperationResult*)pResult status:(NSNumber*)status;
- (void)    onChangeEmailResult:(OperationResult*)pResult status:(NSNumber*)status;
- (void)    onGetEmailResult:(AccountData*)pResult status:(NSNumber*)status;
- (void)	onCountryCodeResult:(JSONModel*)pResult status:(NSNumber*)pStatus;
- (void)    onGetRegionResult:(JSONModel*)pResult status:(NSNumber*)pStatus;
- (void)    onGetCitiesResult:(JSONModel*)pResult status:(NSNumber*)pStatus;
- (void)    onSetShippingResult:(JSONModel*)pResult status:(NSNumber*)pStatus;
- (void)    onBuyerOrdersResult:(JSONModel*)pResult status:(NSNumber*)pStatus;
- (void)    onOrderActionResult:(JSONModel*)pResult status:(NSNumber*)status;
- (void)    onOrderInfoResult:(JSONModel*)pResult status:(NSNumber*)status;
- (void)    onLastMessagesResult:(JSONModel*)pResult status:(NSNumber*)status;
- (void)	onBusinessResult:(BusinessList*)pResult index:(NSNumber*)index status:(NSNumber*)status;
- (void)    onSocialTabResult:(JSONModel*)pResult index:(NSNumber*)index status:(NSInteger)status;
- (void)    onLikeResult:(JSONModel*)pResult data:(id)data status:(NSInteger)status;
- (void)    onTradesResult:(JSONModel*)pResult index:(NSNumber*)index status:(NSInteger)status;
- (void)    onCommentsResult:(JSONModel*)pResult index:(NSNumber*)index status:(NSInteger)status;
- (void)    onAbuseResult:(JSONModel*)pResult status:(NSInteger)status;
- (void)    onAddCommentResult:(JSONModel*)pResult status:(NSInteger)status;
- (void)    onAlbumsResult:(JSONModel*)pResult index:(NSNumber*)index status:(NSInteger)status;
- (void)    onAlbumPhotoResult:(JSONModel*)pResult status:(NSInteger)status;
- (void)    onCreateAlbumResult:(JSONModel*)pResult status:(NSInteger)status;
- (void)    onDeleteAlbumResult:(JSONModel*)pResult status:(NSInteger)status;
- (void)    onDeletePictureResult:(JSONModel*)pResult index:(NSInteger)index status:(NSInteger)status;
- (void)    onFollowersResult:(JSONModel*)pResult index:(NSNumber*)index status:(NSInteger)status;
- (void)    onFollowedsResult:(JSONModel*)pResult index:(NSNumber*)index status:(NSInteger)status;
- (void)    onUploadImageBinaryData:(JSONModel*)pResult status:(NSInteger)status;
- (void)    onTradeDetailsResult:(JSONModel*)pResult status:(NSInteger)status;
- (void)    onBidHistoryResult:(JSONModel*)pResult status:(NSInteger)status;
@required
- (void)    onError:(NSString*)pMessage;
@end
