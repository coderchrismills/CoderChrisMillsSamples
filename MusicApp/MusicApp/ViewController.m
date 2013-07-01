//
//  ViewController.m
//  MusicApp
//
//  Created by Chris Mills on 11/30/11.
//
/****************************************************************************/
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
/****************************************************************************/
#define imgExt @"png"
#define imageToData(x) UIImagePNGRepresentation(x)
/****************************************************************************/
#define DEBUG_MODE
#ifdef DEBUG_MODE
#define DebugLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DebugLog( s, ... )
#endif
/****************************************************************************/
@implementation ViewController
/****************************************************************************/
@synthesize musicPlayer;
/****************************************************************************/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
/****************************************************************************/
#pragma mark - View lifecycle
/****************************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	nCurrentImageViewTypePortrait		= ivt_AlbumArt;
	bCurrentImageViewTypeLandscapeFull	= YES;
	
	nLastPlayIndex		= 0;	// Index into the song we left off on. 
	self.analysisTimer	= nil;	// Timer for calling our analysis function.

	[self setBeatMarkerOn:[UIImage imageNamed:@"icon_beatmarker_on.png"]];
	[self setBeatMarkerOff:[UIImage imageNamed:@"icon_beatmarker_off.png"]];
	
	// Setup weights (twiddle factors)
    fft_weights 		= vDSP_create_fftsetupD(6, kFFTRadix2);
	
    // Allocate memory to store split-complex input and output data 
    input.realp 		= (double *)malloc(MAX_FREQUENCY * sizeof(double));
    input.imagp 		= (double *)malloc(MAX_FREQUENCY * sizeof(double));
	
	fftWaveform			= (double *)malloc(MAX_FREQUENCY * sizeof(double));
	fftData				= (double *)malloc(MAX_FREQUENCY * sizeof(double));
    fftEnergy			= (double *)malloc(MAX_FREQUENCY * sizeof(double));
	
	musicPlayer 		= [MPMusicPlayerController applicationMusicPlayer];
	
	[volumeSlider setValue:[musicPlayer volume]];
	[self registerMediaPlayerNotifications];		// Get notifications on MusicPlayer.
}
/****************************************************************************/
- (void)viewDidUnload
{
	[[NSNotificationCenter defaultCenter] removeObserver: self
													name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
												  object: musicPlayer];
	
	[[NSNotificationCenter defaultCenter] removeObserver: self
													name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
												  object: musicPlayer];
	
	[[NSNotificationCenter defaultCenter] removeObserver: self
													name: MPMusicPlayerControllerVolumeDidChangeNotification
												  object: musicPlayer];
	
	[musicPlayer endGeneratingPlaybackNotifications];
	musicPlayer = nil;
	
	[[self analysisTimer] invalidate];
    [self setAnalysisTimer:nil];
	
	free(fftWaveform);
	free(fftEnergy);
	free(fftData);
	free(input.realp);
    free(input.imagp);
    
    vDSP_destroy_fftsetupD(fft_weights);
    
    [super viewDidUnload];
}
/****************************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
/****************************************************************************/
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
/****************************************************************************/
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}
/****************************************************************************/
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}
/****************************************************************************/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	BOOL bislandscape = UIInterfaceOrientationIsLandscape(interfaceOrientation);
    // Return YES for supported orientations
	[landscapeView setHidden:!bislandscape];
	[portraitView setHidden:bislandscape];
	return YES;	
} 
/****************************************************************************/
#pragma mark - Notifications
/****************************************************************************/
- (void) registerMediaPlayerNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
    [notificationCenter addObserver: self
                           selector: @selector (handle_NowPlayingItemChanged:)
                               name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object: musicPlayer];
	
    [notificationCenter addObserver: self
                           selector: @selector (handle_PlaybackStateChanged:)
                               name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                             object: musicPlayer];
	
    [notificationCenter addObserver: self
                           selector: @selector (handle_VolumeChanged:)
                               name: MPMusicPlayerControllerVolumeDidChangeNotification
                             object: musicPlayer];
	
    [musicPlayer beginGeneratingPlaybackNotifications];
}
/****************************************************************************/
- (void) handle_NowPlayingItemChanged: (id) notification
{
    MPMediaItem *currentItem = [musicPlayer nowPlayingItem];
    UIImage *artworkImage = [UIImage imageNamed:@"unknown_track.png"];
    MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
	
    if (artwork) {
        artworkImage = [artwork imageWithSize: CGSizeMake (200, 200)];
    }
	
    [artworkImageView setImage:artworkImage];
	
    NSString *titleString = [currentItem valueForProperty:MPMediaItemPropertyTitle];
    if (titleString) {
        titleLabel.text = [NSString stringWithFormat:@"Title: %@",titleString];
    } else {
        titleLabel.text = @"Title: Unknown title";
    }
	
    NSString *artistString = [currentItem valueForProperty:MPMediaItemPropertyArtist];
    if (artistString) {
        artistLabel.text = [NSString stringWithFormat:@"Artist: %@",artistString];
    } else {
        artistLabel.text = @"Artist: Unknown artist";
    }
	
    NSString *albumString = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    if (albumString) {
        albumLabel.text = [NSString stringWithFormat:@"Album: %@",albumString];
    } else {
        albumLabel.text = @"Album: Unknown album";
    }
	
}
/****************************************************************************/
- (void) handle_PlaybackStateChanged: (id) notification
{
    MPMusicPlaybackState playbackState = [musicPlayer playbackState];
	
    if (playbackState == MPMusicPlaybackStatePaused) {
        [playPauseButton setImage:[UIImage imageNamed:@"icon_play_off.png"] forState:UIControlStateNormal];
		
    } else if (playbackState == MPMusicPlaybackStatePlaying) {
        [playPauseButton setImage:[UIImage imageNamed:@"icon_pause_off.png"] forState:UIControlStateNormal];
		
    } else if (playbackState == MPMusicPlaybackStateStopped) {
		
        [playPauseButton setImage:[UIImage imageNamed:@"icon_play_off.png"] forState:UIControlStateNormal];
        [musicPlayer stop];
    }
}
/****************************************************************************/
- (void) handle_VolumeChanged: (id) notification
{
    [volumeSlider setValue:[musicPlayer volume]];
}
/****************************************************************************/
#pragma mark - Handle IBActions
/****************************************************************************/
- (IBAction)volumeChanged:(id)sender
{
    [musicPlayer setVolume:[volumeSlider value]];
}
/****************************************************************************/
- (IBAction)playPause:(id)sender
{
    if ([musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        [musicPlayer pause];
		
    } else {
        [musicPlayer play];
    }
}
/****************************************************************************/
- (IBAction)previousSong:(id)sender
{
    [musicPlayer skipToPreviousItem];
	[self loadSongData:[musicPlayer nowPlayingItem]];
}
/****************************************************************************/
- (IBAction)nextSong:(id)sender
{
    [musicPlayer skipToNextItem];
	[self loadSongData:[musicPlayer nowPlayingItem]];
}
/****************************************************************************/
- (IBAction)showMediaPicker:(id)sender
{
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAny];
	
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = NO;
    mediaPicker.prompt = @"Select song to analyze";
	
    [self presentModalViewController:mediaPicker animated:YES];
	mediaPicker = nil;
}
/****************************************************************************/
- (IBAction)toggleWaveformPortrait:(id)sender
{
	nCurrentImageViewTypePortrait = (nCurrentImageViewTypePortrait + 1) % ivt_Count;
	
	BOOL bisalbum = nCurrentImageViewTypePortrait == ivt_AlbumArt;
	BOOL bisfull = nCurrentImageViewTypePortrait == ivt_FullWaveform;
	
	bCurrentImageViewTypeLandscapeFull = bisfull;
	
	[artworkImageView setHidden:!bisalbum];
	
	[fullWaveformImageViewPortrait setHidden:!bisfull];
	[waveformImageViewPortrait setHidden:(bisalbum || bisfull)];
	[fullWaveformImageViewLandscape setHidden:!bisfull];
	[waveformImageViewLandscape setHidden:bisfull];
}
/****************************************************************************/
- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection
{
    if (mediaItemCollection) {
		NSArray *songs = [mediaItemCollection items];
        [musicPlayer setQueueWithItemCollection: mediaItemCollection];
		
		[loadingView setHidden:NO];
		[activityIndicator setHidden:NO];
		[activityIndicator startAnimating];
		
		NSOperationQueue *queue = [[NSOperationQueue alloc] init];
		[queue addOperationWithBlock:^{
			[self loadSongData:(MPMediaItem *)[songs objectAtIndex:0]];
			[[NSOperationQueue mainQueue] addOperationWithBlock:^{
				[activityIndicator stopAnimating];
				[activityIndicator setHidden:YES];
				[loadingView setHidden:YES];
				
				// Start the timer to sample our audio data. 
				float interval_rate = ((songLength / songSampleRate) / MAX_FREQUENCY);
				[self setAnalysisTimer:[NSTimer scheduledTimerWithTimeInterval:interval_rate
                                                                        target:self
                                                                      selector:@selector(doAnalysis:)
                                                                      userInfo:nil
                                                                       repeats:YES]];
				[musicPlayer play];
			}];
		}];		
    }
    [self dismissModalViewControllerAnimated: YES];
}
/****************************************************************************/
- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
    [self dismissModalViewControllerAnimated: YES];
}
/****************************************************************************/
#pragma mark - Song Analysis
/****************************************************************************/
- (void)loadSongData:(MPMediaItem *)mediaitem
{

	NSURL* url = [mediaitem valueForProperty:MPMediaItemPropertyAssetURL];
	AVURLAsset * asset = [[AVURLAsset alloc] initWithURL:url options:nil];

	NSError * error = nil;
	AVAssetReader * reader = [[AVAssetReader alloc] initWithAsset:asset error:&error];

	AVAssetTrack * songTrack = [asset.tracks objectAtIndex:0];

	NSArray* trackDescriptions = songTrack.formatDescriptions;

	numChannels = 2;
	for(unsigned int i = 0; i < [trackDescriptions count]; ++i) {
		CMAudioFormatDescriptionRef item = (__bridge CMAudioFormatDescriptionRef)[trackDescriptions objectAtIndex:i];
		const AudioStreamBasicDescription* bobTheDesc = CMAudioFormatDescriptionGetStreamBasicDescription (item);
		if(bobTheDesc && bobTheDesc->mChannelsPerFrame == 1) {
			numChannels = 1;
		}
	}
	
	const AudioFormatListItem * afli = CMAudioFormatDescriptionGetRichestDecodableFormat((__bridge CMAudioFormatDescriptionRef)[trackDescriptions objectAtIndex:0]);
	songSampleRate = afli->mASBD.mSampleRate;

	DebugLog(@"%f", afli->mASBD.mSampleRate);

	NSDictionary* outputSettingsDict = [[NSDictionary alloc] initWithObjectsAndKeys:
										
										[NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
										[NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
										[NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
										[NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
										[NSNumber numberWithBool:NO],AVLinearPCMIsNonInterleaved,
										
										nil];

	AVAssetReaderTrackOutput * output = [[AVAssetReaderTrackOutput alloc] initWithTrack:songTrack outputSettings:outputSettingsDict];
	[reader addOutput:output];
	
	output = nil;
	
	NSMutableData * fullSongData = [[NSMutableData alloc] init];
	[reader startReading];

	while (reader.status == AVAssetReaderStatusReading){
		AVAssetReaderTrackOutput * trackOutput = (AVAssetReaderTrackOutput *)[reader.outputs objectAtIndex:0];
		CMSampleBufferRef sampleBufferRef = [trackOutput copyNextSampleBuffer];
		
		if (sampleBufferRef){
			CMBlockBufferRef blockBufferRef = CMSampleBufferGetDataBuffer(sampleBufferRef);
			
			size_t length = CMBlockBufferGetDataLength(blockBufferRef);
			
			UInt8 buffer[length];
			CMBlockBufferCopyDataBytes(blockBufferRef, 0, length, buffer);
			
			NSData * data = [[NSData alloc] initWithBytes:buffer length:length];
			[fullSongData appendData:data];
			
			CMSampleBufferInvalidate(sampleBufferRef);
			CFRelease(sampleBufferRef);
			
			data = nil;
		}
	}

	[self setSongData:nil];

	if (reader.status == AVAssetReaderStatusFailed || reader.status == AVAssetReaderStatusUnknown){
		DebugLog(@"Something went wrong...");
		return;
	}

	if (reader.status == AVAssetReaderStatusCompleted){
		[self setSongData:[NSData dataWithData:fullSongData]];
	}
	
	fullSongData		= nil;
	reader				= nil;
	asset				= nil;
	outputSettingsDict	= nil;

	
	songLength = [[self songData] length] / sizeof(SInt16);
	songWaveform = (SInt16 *)[[self songData] bytes];
	
	DebugLog(@"Data length %lu", songLength);
	
	
	UIImage *waveimage = [self audioImageGraphFromRawData:songWaveform withSampleSize:songLength];
	if(waveimage != nil)
	{
		[fullWaveformImageViewLandscape setImage:waveimage];
		[fullWaveformImageViewPortrait setImage:waveimage];
	}
	[self setFullWaveformImage:waveimage];
	
	nLastPlayIndex		= 0;
}
/****************************************************************************/
- (void)doAnalysis:(NSTimer *)timer
{
	[self doBeatAnalysis];
}
/****************************************************************************/
- (void)doBeatAnalysis
{
	MPMusicPlaybackState playbackState = [musicPlayer playbackState];
	
    if (playbackState != MPMusicPlaybackStatePlaying)
		return;
	
	UInt32 data_size = 4096;
	
	int nrange = MIN((nLastPlayIndex + data_size), songLength);
	
	SInt16 max_val = -INT16_MAX; // waveform must be between -1 and 1;
	for (NSInteger i = nLastPlayIndex; i < nrange; i++)
	{
		SInt16 val = abs(songWaveform[i]);
		max_val = MAX(val, max_val);
	}
	
	if(max_val < 1)
	{
		nLastPlayIndex += data_size;
		return;
	}
	
	for (NSInteger i = nLastPlayIndex; i < nrange; i++)
	{
		SInt16 l = songWaveform[i];
		int idx = i-nLastPlayIndex;
		fftWaveform[idx] = ((float)l / (float)max_val);
		fftData[idx] = 0.f;
		fftEnergy[idx] = 0.f;
	}
	
	nLastPlayIndex += data_size;
	
	[self computeFFT];
	
	double ave = 0.f;
	for (int i = 0; i < MAX_FREQUENCY; i++)
	{
		fftData[i] = input.realp[i];
		ave += fftWaveform[i];
		fftEnergy[i] = fftData[i] > 0.0 ? fftData[i]*fftData[i] : 0.0;
	}
	ave /= MAX_FREQUENCY;
	
	UIImage *waveimage = [self audioImageGraph:((nCurrentImageViewTypePortrait == ivt_Waveform) ? fftWaveform : fftEnergy)
									withSampleSize:MAX_FREQUENCY];
	if(waveimage != nil)
	{
		if([portraitView isHidden])
			[waveformImageViewLandscape setImage:waveimage];
		else
			[waveformImageViewPortrait setImage:waveimage];
	}
	
	double std = 0.f;
	for (int i = 0; i < MAX_FREQUENCY; i++)
	{
		std += (fftWaveform[i] - ave) * (fftWaveform[i] - ave);
	}
	std /= MAX_FREQUENCY;
	double power = ave*ave +  std*std;
	
	ave = 0.f;
	for (int i = 0 ; i < MAX_FREQUENCY; i++)
		ave += fftEnergy[i];
	ave /= MAX_FREQUENCY;
	ave = energyToDb((float)ave)*power;
	
    //fftMax = sqrt(fftMax);
	
	float bass = 0.f;
	float viola = 0.f;
	float midc = 0.f;
	float humanhigh = 0.f;
	float high = 0.f;
	
	for (int i = 0; i < MAX_FREQUENCY; i++)
	{
		bass += (i > BASS_INDEX && i < VIOLA_INDEX) ? fftEnergy[i] : 0.f;
		viola += (i > VIOLA_INDEX && i <= MID_C_INDEX) ? fftEnergy[i] : 0.f;
		midc += (i > MID_C_INDEX && i <= HUMAN_HIGH_INDEX) ? fftEnergy[i] : 0.f;
		humanhigh += (i > HUMAN_HIGH_INDEX && i <= HIGH_INDEX) ? fftEnergy[i] : 0.f;
	}
	
	bass /= (VIOLA_INDEX - BASS_INDEX);
	viola /= (MID_C_INDEX - VIOLA_INDEX);
	midc /= (HUMAN_HIGH_INDEX - MID_C_INDEX);
	humanhigh /= (HIGH_INDEX - HUMAN_HIGH_INDEX);
	high /= (MAX_FREQUENCY - HIGH_INDEX);
	
	bass = energyToDb(bass);
	viola = energyToDb(viola);
	midc = energyToDb(midc);
	humanhigh = energyToDb(humanhigh);
	high = energyToDb(high);

	// Values found from 16kHz sweep
	nLastBeatMask = 0;
	
	float range = 1.0f;
	float max_max = fmaxf(fMaxBass, fMaxViola);
	max_max = fmaxf(max_max, fMaxMidC);
	max_max = fmaxf(max_max, fMaxHumanHigh);
	max_max = fmaxf(max_max, fMaxHigh);
	
	if(bass > range * 0.92f * max_max)
		nLastBeatMask |= dbf_Bass;
	if(viola > range * 0.92f * max_max)
		nLastBeatMask |= dbf_Viola;
	if(midc > range * 0.92f * max_max)
		nLastBeatMask |= dbf_Midc;
	if(humanhigh > range * 0.92f * max_max)
		nLastBeatMask |= dbf_HumanHigh;
	if(high > range * 0.85 * max_max)
		nLastBeatMask |= dbf_HighNote;
	
	fMaxBass		= fmaxf(bass, fMaxBass); 
	fMaxViola		= fmaxf(viola, fMaxViola);
	fMaxMidC		= fmaxf(midc, fMaxMidC);
	fMaxHumanHigh	= fmaxf(humanhigh, fMaxHumanHigh);
	fMaxHigh		= fmaxf(high, fMaxHigh);
	
	//DebugLog(@"Intensity: %f, %f, %d", (float)ave, (float)power, nLastBeatMask);
	
	[bassImageView setImage:(nLastBeatMask & dbf_Bass) ? [self beatMarkerOn] : [self beatMarkerOff]];
	[violaImageView setImage:(nLastBeatMask & dbf_Viola) ? [self beatMarkerOn] : [self beatMarkerOff]];
	[midcImageView setImage:(nLastBeatMask & dbf_Midc) ? [self beatMarkerOn] : [self beatMarkerOff]];
	[humanHighImageView setImage:(nLastBeatMask & dbf_HumanHigh) ? [self beatMarkerOn] : [self beatMarkerOff]];
	[highImageView setImage:(nLastBeatMask & dbf_HighNote) ? [self beatMarkerOn] : [self beatMarkerOff]];
	
	float intensity_out = (float)(ave);
	intensityLabel.text = [NSString stringWithFormat:@"Intensity : %f", intensity_out];

	[self.view setNeedsDisplay];
}
/****************************************************************************/
- (UIImage *)audioImageGraph:(double *)samples withSampleSize:(int)sample_size
{
	// Compute the bounds of the data. 
	float max_val = -MAXFLOAT;
	for (int i = 0; i < sample_size; i++)
	{
		max_val = MAX(max_val, fabsf(samples[i]));
	}
	
	CGSize sz = waveformImageViewLandscape.frame.size;
	float samplecount = sz.width;
	float imageheight = sz.height;
    CGSize imageSize = CGSizeMake(samplecount, imageheight);
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetAlpha(context,1.0);
    CGRect rect;
    rect.size = imageSize;
    rect.origin.x = 0;
    rect.origin.y = 0;
	
    CGColorRef leftcolor = [[UIColor orangeColor] CGColor];
	
    CGContextFillRect(context, rect);
	
    CGContextSetLineWidth(context, 1.0);
	
    float halfGraphHeight = (imageheight / 2);
    float centerLeft = halfGraphHeight;
	int stepsize = sample_size / samplecount;
	stepsize = MAX(stepsize, 1);
	int count = 0;
    for (int i = 0; i < sample_size; i+=stepsize ) 
	{
        float pixels = halfGraphHeight * ((float)samples[i] / max_val);
        CGContextMoveToPoint(context, count, centerLeft-pixels);
        CGContextAddLineToPoint(context, count, centerLeft+pixels);
        CGContextSetStrokeColorWithColor(context, leftcolor);
        CGContextStrokePath(context);
		count++;
    }
	
    // Create new image
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	
    // Tidy up
    UIGraphicsEndImageContext();   
	
    return newImage;
}
/****************************************************************************/
- (UIImage *)audioImageGraphFromRawData:(SInt16 *)samples withSampleSize:(int)sample_size
{
	// Compute the bounds of the data. 
	SInt16 max_val = -INT16_MAX;
	for (NSInteger i = 0; i < sample_size; i++)
	{
		SInt16 val = abs(samples[i]);
		max_val = MAX(val, max_val);
	}
	
	CGSize sz =  waveformImageViewLandscape.frame.size;
	float samplecount = sz.width;
	float imageheight = sz.height;
    CGSize imageSize = CGSizeMake(samplecount, imageheight);
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetAlpha(context,1.0);
    CGRect rect;
    rect.size = imageSize;
    rect.origin.x = 0;
    rect.origin.y = 0;
	
    CGColorRef leftcolor = [[UIColor blueColor] CGColor];
	
    CGContextFillRect(context, rect);
	
    CGContextSetLineWidth(context, 1.0);
	
    float halfGraphHeight = (imageheight / 2);
    float centerLeft = halfGraphHeight;
	NSInteger stepsize = sample_size / samplecount;
	stepsize = MAX(stepsize, 1);
	int count = 0;
    for (NSInteger i = 0; i < sample_size; i+=stepsize ) 
	{
        float pixels = halfGraphHeight * ((float)samples[i] / (float)max_val);
        CGContextMoveToPoint(context, count, centerLeft-pixels);
        CGContextAddLineToPoint(context, count, centerLeft+pixels);
        CGContextSetStrokeColorWithColor(context, leftcolor);
        CGContextStrokePath(context);
		count++;
    }
	
    // Create new image
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	
    // Tidy up
    UIGraphicsEndImageContext();   
	
    return newImage;
}
/****************************************************************************/
- (void)computeFFT
{
	// Using Accelerate Framework to compute the fft. This should be the framework
	// you use if you're targeting iOS 4.0 and above. 
	for (NSUInteger i = 0; i < MAX_FREQUENCY; i++)
    {
        input.realp[i] = (double)fftWaveform[i];
        input.imagp[i] = 0.0f;
    }
	
    /* 1D in-place complex FFT */
    vDSP_fft_zipD(fft_weights, &input, 1, 6, FFT_FORWARD);  
	
    input.realp[0] = 0.0;
    input.imagp[0] = 0.0;
}
/****************************************************************************/
@end
