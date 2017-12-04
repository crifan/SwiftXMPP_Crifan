/*
 * Copyright 2010-present Facebook.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "FBSettingsTests.h"
#ifndef FB_BUILD_ONLY
#define FB_BUILD_ONLY
#endif

#import "FBSettings.h"

#ifdef FB_BUILD_ONLY
#undef FB_BUILD_ONLY
#endif

@implementation FBSettingsTests

- (void)testBetaMode
{
    STAssertFalse([FBSettings isBetaFeatureEnabled:FBBetaFeaturesShareDialog], @"share dialog not enabled");
    [FBSettings enableBetaFeature:FBBetaFeaturesOpenGraphShareDialog];
    STAssertTrue([FBSettings isBetaFeatureEnabled:FBBetaFeaturesOpenGraphShareDialog], @"OG share dialog enabled");
    [FBSettings disableBetaFeature:FBBetaFeaturesOpenGraphShareDialog];
    STAssertFalse([FBSettings isBetaFeatureEnabled:FBBetaFeaturesOpenGraphShareDialog], @"OG share dialog disabled");
    [FBSettings enableBetaFeatures:FBBetaFeaturesShareDialog | FBBetaFeaturesOpenGraphShareDialog];
    STAssertTrue([FBSettings isBetaFeatureEnabled:FBBetaFeaturesOpenGraphShareDialog], @"OG share dialog enabled");
    STAssertTrue([FBSettings isBetaFeatureEnabled:FBBetaFeaturesShareDialog], @"share dialog enabled");
    [FBSettings disableBetaFeature:FBBetaFeaturesShareDialog];
    STAssertTrue([FBSettings isBetaFeatureEnabled:FBBetaFeaturesOpenGraphShareDialog], @"OG share dialog enabled");
    STAssertFalse([FBSettings isBetaFeatureEnabled:FBBetaFeaturesShareDialog], @"share dialog enabled");
    [FBSettings disableBetaFeature:FBBetaFeaturesOpenGraphShareDialog];
    STAssertFalse([FBSettings isBetaFeatureEnabled:FBBetaFeaturesOpenGraphShareDialog], @"OG share dialog disabled");
    STAssertFalse([FBSettings isBetaFeatureEnabled:FBBetaFeaturesShareDialog], @"share dialog enabled");
}

@end
