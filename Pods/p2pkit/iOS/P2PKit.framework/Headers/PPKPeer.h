/**
 * PPKPeer.h
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


/*!
 *  @abstract       The Proximity Strength of a peer.
 *
 *  @discussion     Proximity Ranging adds context to the discovery events by providing 5 levels of proximity strength (from “immediate” to “extremely weak”). You could associate "proximity strength" with distance, but due to the unreliable nature of signal strength (different hardware, environmental conditions, etc.) we preferred not to associate the two. Nevertheless, in many cases you will be able to determine who is the closest peer to you (if he is significantly closer than others).<br/><br/><strong>Note:</strong> Proximity ranging only works in the foreground. Not all Android devices have the capability to be ranged by other peers.<br/><br/><strong>Note:</strong> Proximity strength relies on the signal strength and can be affected by various factors in the environment.
 *
 *  @see            <code> PPKPeer.proximityStrength </code>
 */
typedef NS_ENUM(NSInteger, PPKProximityStrength) {

    /*! Proximity strength cannot be determined and is not known. */
    PPKProximityStrengthUnknown,
    
    /*! Proximity strength is extremely weak. */
    PPKProximityStrengthExtremelyWeak,
    
    /*! Proximity strength is weak. */
    PPKProximityStrengthWeak,
    
    /*! Proximity strength is medium. */
    PPKProximityStrengthMedium,
    
    /*! Proximity strength is strong. */
    PPKProximityStrengthStrong,
    
    /*! Proximity strength is immediate. */
    PPKProximityStrengthImmediate
};


/*!
 *  <code>PPKPeer</code> represents an instance of a nearby peer.
 */
@interface PPKPeer : NSObject

/*!
 *  @abstract       A unique identifier for the peer. P2PKit generates this ID when you enable <code> PPKController </code> for the first time. When the app is re-installed a new ID is generated.
 */
@property (readonly, nonnull) NSString *peerID;

/*!
 *  @abstract       A <code>NSData</code> object containing the discovery info of the peer (can be nil if the peer does not provide a discovery info).
 */
@property (readonly, nullable) NSData *discoveryInfo;

/*!
 *  @abstract       Indicates the current Proximity Strength of the peer.
 *
 *  @warning        Please note that the proximity strength relies on the signal strength and can be affected by various factors in the environment.
 *
 *  @see            PPKProximityStrength
 */
@property (readonly) PPKProximityStrength proximityStrength;

@end
