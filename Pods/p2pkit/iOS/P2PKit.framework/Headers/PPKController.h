/**
 * PPKController.h
 * P2PKit
 *
 * Copyright (c) 2017 by Uepaa AG, Zürich, Switzerland.
 * All rights reserved.
 *
 * We reserve all rights in this document and in the information contained therein.
 * Reproduction, use, transmission, dissemination or disclosure of this document and/or
 * the information contained herein to third parties in part or in whole by any means
 * is strictly prohibited, unless prior written permission is obtained from Uepaa AG.
 *
 */

#import <Foundation/Foundation.h>
#import "PPKPeer.h"

#define P2PKIT_VERSION @"2.1.0"

/*!
 *  Discovery engine states.
 */
typedef NS_ENUM(NSInteger, PPKDiscoveryState) {
    
    /*! Discovery is disabled.*/
    PPKDiscoveryStateStopped = 0,
    
    /*! Discovery is not supported on this device (e.g. BLE is not available).*/
    PPKDiscoveryStateUnsupported,
    
    /*! Discovery is not able to run because of a missing user permission.*/
    PPKDiscoveryStateUnauthorized,
    
    /*! Discovery is temporarily suspended. The discovery engine will try to restart as soon as possible (e.g. after the user did re-enable BLE).*/
    PPKDiscoveryStateSuspended,
    
    /*! Discovery is temporarily suspended because the server connection is unavailable. The discovery engine will try to restart as soon as possible (e.g. after server connection is available again).*/
    PPKDiscoveryStateServerConnectionUnavailable,
    
    /*! Discovery is running: the device will discover other peers and will be discovered by other peers.*/
    PPKDiscoveryStateRunning
    
};

/*!
 *  P2PKit initialization error codes. Errors are not recoverable and will be treated as fatal.
 */
typedef NS_ENUM(NSInteger, PPKErrorCode) {
    
    /*! P2PKit initialization failed due to an invalid App Key. Please obtain your App Key in the <code><a href="https://p2pkit-console.uepaa.ch/">p2pkit console</a></code>.*/
    PPKErrorInvalidAppKey = 0,
    
    /*! Server connection failed due to a server incompatibility. Please update to the most recent version of the framework.*/
    PPKErrorIncompatibleClientVersion = 2,
    
    /*! P2PKit initialization failed due to an invalid bundle ID. Please configure your bundle IDs in the <code><a href="https://p2pkit-console.uepaa.ch/">p2pkit console</a></code>.*/
    PPKErrorInvalidBundleId = 5
};

/*!
 *  Messaging API delivery codes.
 */
typedef NS_ENUM(NSInteger, PPKMessageDeliveryCode) {
    
    /*! Message has been queued for dispatch, this does not guarantee the delivery of the message.*/
    PPKMessageDeliveryCodeDispatched = 0,
    
    /*! AppKey is not eligible for sending direct messages, please upgrade your account.*/
    PPKMessageDeliveryCodeMessagingNotAllowed,
    
    /*! API throttled, messaging rate is limited to 20 messages per second.*/
    PPKMessageDeliveryCodeThrottled,
    
    /*! Target Peer is not currently discovered.*/
    PPKMessageDeliveryCodePeerUnknown,
    
    /*! Server connection unavailable.*/
    PPKMessageDeliveryCodeServerConnectionUnavailable,
    
    /*! Discovery is not running.*/
    PPKMessageDeliveryCodeDiscoveryNotRunning
};

typedef void(^MessageDeliveryStatusBlock)(PPKMessageDeliveryCode code);

#pragma mark - PPKControllerDelegate

/*!
 *  Delivers lifecycle and discovery events
 */
@protocol PPKControllerDelegate <NSObject>
@optional


/*!
 *  @name   Lifecycle
 */
#pragma mark Lifecycle

/*!
 *  @abstract     Indicates successful initialization of the P2PKit. You must not call other methods before this delegate method has been called.
 */
-(void)PPKControllerInitialized;

/*!
 *  @abstract           Indicates an error with P2PKit (e.g. invalid configuration or server incompatibility due to an outdated version).
 *
 *  @param errorCode    error code corresponding to <code> PPKErrorCode </code>
 *
 *  @see                <code> PPKErrorCode </code>
 */
-(void)PPKControllerFailedWithError:(PPKErrorCode)errorCode;


/*!
 *  @name   Discovery
 */
#pragma mark Discovery

/*!
 *  @abstract       Indicates a state change of the discovery engine (e.g. discovery is temporarily suspended because the user disabled Bluetooth).
 *
 *  @param state    The current state of the discovery engine as indicated by <code> PPKDiscoveryState. </code>
 *
 *  @see            <code> PPKDiscoveryState </code>
 */
-(void)discoveryStateChanged:(PPKDiscoveryState)state;

/*!
 *  @abstract       Reports the discovery of a nearby peer.
 *
 *  @param peer     An object of type <code> PPKPeer </code> representing the nearby peer
 */
-(void)peerDiscovered:(nonnull PPKPeer*)peer;

/*!
 *  @abstract       Called if a recently discovered peer is no longer nearby. P2PKit tries to determine when a peer is no longer nearby on a best effort basis.
 *
 *  @param peer     An object of type <code> PPKPeer </code> representing the nearby peer
 */
-(void)peerLost:(nonnull PPKPeer*)peer;

/*!
 *  @abstract       Called if a discovered peer updated his discovery info.
 *
 *  @param peer     An object of type <code> PPKPeer </code> representing the nearby peer
 */
-(void)discoveryInfoUpdatedForPeer:(nonnull PPKPeer*)peer;

/*!
 *  @abstract       Called if the proximity strength for a peer changes.
 *
 *  @param peer     An object of type <code> PPKPeer </code> representing the nearby peer
 *
 *  @see            <code> PPKProximityStrength </code>
 */
-(void)proximityStrengthChangedForPeer:(nonnull PPKPeer*)peer;

/*!
 *  @abstract       Called if a message is received from a nearby peer.
 *
 *  @param message  An object of type <code> NSData </code> containing the message payload
 *
 *  @param peer     An object of type <code> PPKPeer </code> representing the nearby peer
 */
-(void)messageReceived:(nonnull NSData*)message fromNearbyPeer:(nonnull PPKPeer*)peer;

@end



#pragma mark - PPKController

/*!
 *  <code> PPKController </code> is your entry point to P2PKit. You will interact with P2PKit via static methods, never try to obtain an instance of <code> PPKController. </code>
 */
@interface PPKController : NSObject


/*!
 *  @name   Lifecycle
 */
#pragma mark Lifecycle

/*!
 *  @abstract           Initializes P2PKit asynchronously. This method returns immediately.
 *
 *  @discussion         If the enabling is successful, <code> PPKControllerInitialized </code> is called.<br/> On a failure, <code> PPKControllerFailedWithError </code> is called.<br/> If p2pkit is already enabled, a consecutive call to this method will result in an exception.<br/><br/><b>Note:</b> Calling this method constitutes a P2PKit usage event.
 *
 *  @param appKey       The App Key you have obtained via the console. You can manage your App Keys over the <code><a href="https://p2pkit-console.uepaa.ch/">p2pkit console</a></code>
 *
 *  @param observer     Your (partial) implementation of the <code> PPKControllerDelegate </code> protocol
 *
 *  @warning            This method must be called once before any other interaction with <code>PPKController</code>.<br/> If p2pkit is already initialized or the App Key is invalid, this method will throw an <code> NSException </code>.
 *
 *  @throws             <code> NSException </code> if p2pkit is already initialized.
 *
 *  @see                <code> PPKControllerDelegate </code>
 */
+(void)enableWithConfiguration:(nonnull NSString*)appKey observer:(nonnull id<PPKControllerDelegate>)observer;

/*!
 *  @abstract           Shuts-down and terminates P2PKit.
 */
+(void)disable;

/*!
 *  @abstract           Returns YES if P2PKit is already enabled.
 *
 *  @note               P2PKit could still be in the enabling process when you call this method, as it only checks if you already made a call to enable P2PKit. Use the <code>PPKControllerInitialized</code> delegate callback to be informed when P2PKit succeeded with enabling.
 */
+(BOOL)isEnabled;

/*!
 *  @abstract           Returns the unique peer ID of the current app.
 *
 *  @return             The unique peer ID of the current app. P2PKit generates this ID when you enable <code> PPKController </code> for the first time.
 */
+(nonnull NSString*)myPeerID;

/*!
 *  @abstract           Registers an additional observer.
 *
 *  @param observer     Your (partial) implementation of the <code> PPKControllerDelegate </code> protocol
 *
 *  @see                <code> PPKControllerDelegate </code>
 */
+(void)addObserver:(nonnull id<PPKControllerDelegate>)observer;

/*!
 *  @abstract           Removes an already registered observer.
 *
 *  @param observer     Registered observer
 */
+(void)removeObserver:(nonnull id<PPKControllerDelegate>)observer;


/*!
 *  @name   Discovery
 */
#pragma mark Discovery

/*!
 *  @abstract       Starts discovery with discovery info (after successful startup, you will discover nearby peers and will be discovered by nearby peers).
 *
 *  @param info     <code> NSData </code> object, can be nil but not longer than <code> getDiscoveryInfoMaxSize </code>
 *
 *  @param enabled  Whether to enable CoreBluetooth State Preservation and Restoration (not supported on OS X)
 *
 *  @discussion     p2pkit can use the CoreBluetooth State Preservation and Restoration API. State restoration enables p2pkit-enabled apps to continue to discover and be discovered even if the application has crashed or was terminated by the OS. In order for state restoration to work, you would need to <code> startDiscoveryWithDiscoveryInfo:stateRestoration: </code> when the application is relaunched.<br/> State Restoration is not supported on OS X. 
 *
 *                  Discovery info is transferred over our cloud, however, it is not end-to-end encrypted. Hence we recommend not sending any sensitive data through this API.
 *
 *  @note           Please make sure you <code> stopDiscovery </code> when your end-user no longer wishes to discover or be discovered.
 *
 *  @throws         <code> NSException </code> if the discovery info is too long.
 */
+(void)startDiscoveryWithDiscoveryInfo:(nullable NSData*)info stateRestoration:(BOOL)enabled;

/*!
 *  @abstract       Returns the current state of the discovery engine.
 *
 *  @return         The current state of the discovery engine.
 *
 *  @see            PPKDiscoveryState
 */
+(PPKDiscoveryState)discoveryState;

/*!
 *  @abstract       Updates your discovery info. The new discovery info is exchanged with other peers on a best effort basis and is not guaranteed. If a nearby peer has lost his connection to our cloud he will not receive the updated version until he is rediscovered.
 *
 *  @param info     <code> NSData </code> object, can be nil but not longer than <code> getDiscoveryInfoMaxSize </code>
 *
 *  @discussion     The use of this API is limited based on the tier edition (60s for the Community Edition and 15s for the Pro Edition). If you push discovery info more often or if the discovery info is too long, this method will throw an <code> NSException </code>.
 *
 *                  Discovery info is transferred over our cloud, however, it is not end-to-end encrypted. Hence we recommend not sending any sensitive data through this API.
 *
 *  @throws         <code> NSException </code> if called more than once per 60 seconds or if the discovery info is too long.
 */
+(void)pushNewDiscoveryInfo:(nullable NSData*)info;

/**
 *  Returns the max size allowed for discovery info in bytes.
 *
 *  Currently set to 440 bytes.
 *
 *  @return integer containing the max size allowed for discovery info in bytes.
 */
+(NSInteger)getDiscoveryInfoMaxSize;

/*!
 *  @abstract       Enables Proximity Ranging of nearby peers.
 *
 *  @discussion     Discovered peers will be continuously ranged. Updates will be delivered through the <code> proximityStrengthChangedForPeer: </code> delegate method. Please refer to <code> PPKProximityStrength </code> for possible proximity strength values.
 *
 *  @note           Proximity ranging only works in the foreground. Not all Android devices have the capability to be ranged by other peers.
 *
 *  @note           Proximity strength relies on the signal strength and can be affected by various factors in the environment.
 *
 *  @see            <code> PPKProximityStrength </code>
 */
+(void)enableProximityRanging;

/*!
 *  @abstract       Stops discovery (you will no longer discover peers and will no longer be discovered by peers).
 */
+(void)stopDiscovery;


/*!
 *  @name   Messaging
 */
#pragma mark Messaging

/*!
 *  @abstract       Returns YES if your AppKey is eligible for the messaging API. Messaging is only available for Pro Edition AppKeys.
 *
 *  @return         YES if messaging API is available for your AppKey.
 *
 *  @note           If p2pkit is enabled while offline this method returns NO regardless. To make sure you get the correct response, wait until the discovery state reports <code> PPKDiscoveryStateRunning </code> before calling this method.
 */
+(BOOL)isMessagingAvailable;

/*!
 *  @abstract       Send a simple payload to a nearby peer.
 *
 *  @param message  <code> NSData </code> object, not bigger than <code> getMessageMaxSize </code>.
 *
 *  @param peer     <code> PPKPeer </code> object as message recipient. Cannot be nil. The peer must be curently discovered.
 *
 *  @param block    <code> MessageDeliveryStatusBlock </code> will be called with the appropriate <code> PPKMessageDeliveryCode </code>.
 *
 *  @discussion     A nearby peer will only receive the message if it has been discovered and is currently reachable. Message delivery is not guaranteed. The use of this API is limited to 20 messages per second.
 *
 *                  Messages are transferred over our cloud, however, they are not end-to-end encrypted. Hence we recommend not sending any sensitive data through this API.
 *
 *  @note           This API is only available for Pro Edition AppKeys.
 */
+(void)sendMessage:(nonnull NSData*)message toNearbyPeer:(nonnull PPKPeer*)peer withDeliveryStatusBlock:(nullable MessageDeliveryStatusBlock)block;

/**
 *  Returns the max byte size allowed for messages.
 *
 *  Currently set to 100kB.
 *
 *  @return integer containing the max byte size allowed for messages.
 */
+(NSInteger)getMessageMaxSize;

@end
