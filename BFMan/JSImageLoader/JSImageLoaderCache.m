/*
 Copyright (c) 2011 Jernej Strasner
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software
 and associated documentation files (the "Software"), to deal in the Software without restriction,
 including without limitation the rights to use, copy, modify, merge, publish, distribute,
 sublicense, and/or sell copies of the Software, and to permit persons to whom the Software
 is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or
 substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
 PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
 FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
 */
//
//  DiskCache.m
//  JSImageCache
//
//  Created by Jernej Strasner on 5/23/11.
//  Copyright 2011 JernejStrasner.com. All rights reserved.
//

#import "JSImageLoaderCache.h"

#import "NSString+MD5.h"

#import <libkern/OSAtomic.h>
#import "MBProgressHUD.h"

@interface JSImageLoaderCache (Privates)

- (void)trimDiskCacheFilesToMaxSize:(NSUInteger)targetBytes;

@end


@implementation JSImageLoaderCache

@synthesize sizeOfCache, cacheDir, trimming = _trimming;

#pragma mark Initialization

- (id)init {
	self = [super init];
	if (self) {
		// Clean the cache
		//[self trimDiskCacheFilesToMaxSize:kMaxDiskCacheSize];
	}
	return self;	
}

#pragma mark Singleton

/*
 * Singleton pattern by Louis Gerbarg
 * http://stackoverflow.com/questions/145154/what-does-your-objective-c-singleton-look-like/2449664#2449664
 */

static void * volatile sharedInstance = nil;

+ (JSImageLoaderCache *)sharedCache {
	while (!sharedInstance) {
		JSImageLoaderCache *temp = [[self alloc] init];
		if(!OSAtomicCompareAndSwapPtrBarrier(0x0, temp, &sharedInstance)) {
			[temp release];
		}
	}
	return sharedInstance;
}

#pragma mark Paths

- (NSString *)cacheDir {
	// Check if the cache dir is set
	if (_cacheDir == nil) {
		// Build the cache dir path
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
		_cacheDir = [[NSString alloc] initWithString:[[paths objectAtIndex:0] stringByAppendingPathComponent:@"URLCache"]];
	}
	
	// Check of the cache dir exists
	if (![[NSFileManager defaultManager] fileExistsAtPath:_cacheDir]) {
		// If it doesn't exist create it
		if (![[NSFileManager defaultManager] createDirectoryAtPath:_cacheDir withIntermediateDirectories:NO attributes:nil error:nil]) {
			NSLog(@"Error creating cache directory");
		}
	}
	
	// Finally return the path to it
	return _cacheDir;
}

- (NSString *)localPathForURL:(NSURL *)url {
	// Build the file name
	NSString *filename = [[url absoluteString] md5];

	// Return the full local path
	return [[self cacheDir] stringByAppendingPathComponent:filename];
}

#pragma mark Get the cached data

- (NSData *)imageDataInCacheForURLString:(NSString *)urlString {
	// Get the path for the local file equivalent
	NSString *localPath = [self localPathForURL:[NSURL URLWithString:urlString]];
	
	// Check of it exists
	if ([[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
		// "touch" the file so we know when it was last used
		[[NSFileManager defaultManager] setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], NSFileModificationDate, nil] 
										 ofItemAtPath:localPath 
												error:nil];
		// Return the file data
		return [[NSFileManager defaultManager] contentsAtPath:localPath];
	}
	
	// Else return nil
	return nil;
}

#pragma mark Cache data

- (void)cacheImageData:(NSData *)imageData request:(NSURLRequest *)request response:(NSURLResponse *)response {
	// Check of all the parameters are present and valid
	if (request != nil && response != nil && imageData != nil) {
		// Create a cached url response
		NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:imageData];
		// Store it in the url cache
		//[[NSURLCache sharedURLCache] storeCachedResponse:cachedResponse forRequest:request];
		
		// Trim the ache if it exceeds the max size
        /*
		if ([self sizeOfCache] >= kMaxDiskCacheSize && !self.trimming) {
            self.trimming = YES;
			[self trimDiskCacheFilesToMaxSize:kMaxDiskCacheSize * 0.6];
            self.trimming = NO;
		}
		*/
		// Get the local file path
		NSString *localPath = [self localPathForURL:[request URL]];
		
		// Check if the file exists at the path
		if (![[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
			// Try to create the file with the provided data
			if (![[NSFileManager defaultManager] createFileAtPath:localPath contents:imageData attributes:nil]) {
				NSLog(@"ERROR: Could not create file at path: %@", localPath);
			} else {
				// If the file was sucessfully created increase the total cache size by the size of the just cache data
				_cacheSize += [imageData length];
			}
		}
		
		// Clean up
        [cachedResponse release];
	}
}

#pragma mark Cache cleaning

- (void)clearCachedDataForRequest:(NSURLRequest *)request {
	// Remove the cache in the shared URL cache
	//[[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
	// Get the data of the disk cache for the request
	NSData *data = [self imageDataInCacheForURLString:[[request URL] path]];
	// Decrease the total cache size by the data that will be removed
	_cacheSize -= [data length];
	// Remove the cache file from disk
	[[NSFileManager defaultManager] removeItemAtPath:[self localPathForURL:[request URL]] error:nil];
}

- (NSUInteger)sizeOfCache {
	// Get the path of the cache directory
	NSString *cacheDirectory = [self cacheDir];
	// Check if the cache size is not calculated yet and that the cache directory is valid
	if (_cacheSize <= 0 && cacheDirectory) {
		// Get the contents of the cache
		NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cacheDirectory error:nil];
		// Variables for the loop
		NSDictionary *attrs;
		NSNumber *fileSize;
		NSUInteger totalSize = 0;
		// Loop trough the cache contents
		for (NSString *file in dirContents) {
			// Get the file extension
            attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:[cacheDirectory stringByAppendingPathComponent:file] error:nil];
            // Get the file size from the attributes dictionary
            fileSize = [attrs objectForKey:NSFileSize];
            // Add to the total cache size
            totalSize += [fileSize integerValue];
		}
		// Assign to the ivar
		_cacheSize = totalSize;
	}

	// Return the total cache size
	return _cacheSize;
}


- (void)trimDiskCacheFilesToZero:(MBProgressHUD *)hud {
	// Determine the target size of the cache
	NSInteger targetBytes = 0;
	// Check if the currnet cache size is bigger than the target
    NSInteger totalSize = [self sizeOfCache];
    
	if (totalSize > targetBytes) {
		// Get the cache contents
		NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self cacheDir] error:nil];
		
		NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
        
        NSString *cacheDirectory = [self cacheDir];
		// Loop trough the cache contents and filter out images (jpg, png)
		for (NSString *file in dirContents) {
            [filteredArray addObject:[cacheDirectory stringByAppendingPathComponent:file]];
		}
		/*
         // Sort the images by modification date
         NSMutableArray *sortedDirContents = [[filteredArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
         NSDictionary *attrs1 = [[NSFileManager defaultManager] attributesOfItemAtPath:obj1 error:nil];
         NSDictionary *attrs2 = [[NSFileManager defaultManager] attributesOfItemAtPath:obj2 error:nil];
         return [[attrs2 objectForKey:NSFileModificationDate] compare:[attrs1 objectForKey:NSFileModificationDate]];
         }] mutableCopy];
         */
		// While the cache size is bigger than the target size and the cache contents still exist
        NSError *error = nil;
		while (_cacheSize > targetBytes && [filteredArray count] > 0) {
			// Decrease the total cache size b the size of the file to be removed
            NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:[filteredArray lastObject] error:&error];
			_cacheSize -= [[attrs objectForKey:NSFileSize] integerValue];
			// Remove the file
			[[NSFileManager defaultManager] removeItemAtPath:[filteredArray lastObject] error:&error];
			// Remove from the array
			[filteredArray removeLastObject];
            
            hud.progress = 1 - ((float)_cacheSize)/totalSize;
		}
		// Clean up
        [filteredArray release];
        //[sortedDirContents release];
	}
}
#pragma mark Memory management

- (void)dealloc {
	[_cacheDir release];
	
	[super dealloc];
}

@end
