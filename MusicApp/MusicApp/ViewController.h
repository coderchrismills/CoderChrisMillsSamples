//
//  ViewController.h
//  MusicApp
//
//  Created by Chris Mills on 11/30/11.
//
/****************************************************************************/
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Accelerate/Accelerate.h>
/****************************************************************************/
#define MAX_FREQUENCY		4096
/****************************************************************************/
#define BASS_INDEX			40
#define VIOLA_INDEX			110
#define MID_C_INDEX			196
#define HUMAN_HIGH_INDEX	261
#define HIGH_INDEX			523
/****************************************************************************/
enum DBF
{
	dbf_Bass		= 1 << 0,
	dbf_Viola		= 1 << 1,
	dbf_Midc		= 1 << 2,
	dbf_HumanHigh	= 1 << 3,
	dbf_HighNote	= 1 << 4,
	dbf_Max
};
/****************************************************************************/
enum ImageViewType
{
	ivt_AlbumArt,
	ivt_Waveform,
	ivt_Energy,
	ivt_FullWaveform,
	ivt_Count
};
/****************************************************************************/
static inline float energyToDb(float energy)
{
	return energy > 0.f ? 10.f * (float)log10((double)energy/(1.0e-13)) : 0.f; 
}
/****************************************************************************/
@interface ViewController : UIViewController <MPMediaPickerControllerDelegate> {
	
	// Interface and UI
	IBOutlet UIView			*portraitView;
	IBOutlet UIView			*landscapeView;
	IBOutlet UIView			*loadingView;
	
	IBOutlet UIActivityIndicatorView	*activityIndicator;
	
	IBOutlet UIImageView	*artworkImageView;
	IBOutlet UIImageView	*bassImageView;
	IBOutlet UIImageView	*violaImageView;
	IBOutlet UIImageView	*midcImageView;
	IBOutlet UIImageView	*humanHighImageView;
	IBOutlet UIImageView	*highImageView;

	IBOutlet UIImageView	*waveformImageViewPortrait;
	IBOutlet UIImageView	*fullWaveformImageViewPortrait;
	
	IBOutlet UIImageView	*waveformImageViewLandscape;
	IBOutlet UIImageView	*fullWaveformImageViewLandscape;
	
	IBOutlet UIButton		*previousButton;
	IBOutlet UIButton		*nextButton;
	IBOutlet UIButton		*playPauseButton;
	IBOutlet UIButton		*songSelectButton;
	
	IBOutlet UISlider		*volumeSlider;
	
	IBOutlet UILabel *titleLabel;
	IBOutlet UILabel *artistLabel;
	IBOutlet UILabel *albumLabel;
	IBOutlet UILabel *intensityLabel;
	IBOutlet UILabel *powerLabel;
	
	int		nCurrentImageViewTypePortrait;
	BOOL	bCurrentImageViewTypeLandscapeFull;
	
	// Main music player
	MPMusicPlayerController	*musicPlayer;
	
	// Audio information
	unsigned long			songLength;
	NSInteger				nLastPlayIndex;
	float					songSampleRate;
	int						numChannels;
	
	// Beat information
	int nLastBeatMask;
	float fMaxBass; 
	float fMaxViola;
	float fMaxMidC;
	float fMaxHumanHigh;
	float fMaxHigh;
	float fMaxSpecRate;
	
	// FFT Stuff
	SInt16						*songWaveform;
	FFTSetupD					fft_weights;
	DSPDoubleSplitComplex		input;
	double						*fftWaveform;
	double						*fftData;
	double						*fftEnergy;
	
}
/****************************************************************************/
@property (nonatomic, strong) MPMusicPlayerController	*musicPlayer;
@property (nonatomic, strong) NSData                    *songData;
@property (nonatomic, strong) NSTimer					*analysisTimer;
@property (nonatomic, strong) UIImage                   *beatMarkerOn;
@property (nonatomic, strong) UIImage                   *beatMarkerOff;
@property (nonatomic, strong) UIImage                   *fullWaveformImage;
/****************************************************************************/
- (IBAction)volumeChanged:(id)sender;
- (IBAction)showMediaPicker:(id)sender;
- (IBAction)previousSong:(id)sender;
- (IBAction)playPause:(id)sender;
- (IBAction)nextSong:(id)sender; 
- (IBAction)toggleWaveformPortrait:(id)sender;
/****************************************************************************/
- (void)registerMediaPlayerNotifications;
/****************************************************************************/
- (void)loadSongData:(MPMediaItem *)mediaitem;
- (void)doAnalysis:(NSTimer *)timer;
- (void)doBeatAnalysis;
/****************************************************************************/
- (void)computeFFT;
- (UIImage *)audioImageGraph:(double *)samples withSampleSize:(int)sample_size;
- (UIImage *)audioImageGraphFromRawData:(SInt16 *)samples withSampleSize:(int)sample_size;
@end
