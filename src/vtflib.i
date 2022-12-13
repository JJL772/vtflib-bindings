%module VTFLib

%{
#include "VTFLib.h"
using namespace VTFLib;
%}

typedef struct tagSVTFImageFormatInfo
{
	const vlChar *lpName;			//!< Enumeration text equivalent.
	vlUInt	uiBitsPerPixel;			//!< Format bits per pixel.
	vlUInt	uiBytesPerPixel;		//!< Format bytes per pixel.
	vlUInt	uiRedBitsPerPixel;		//!< Format red bits per pixel.  0 for N/A.
	vlUInt	uiGreenBitsPerPixel;	//!< Format green bits per pixel.  0 for N/A.
	vlUInt	uiBlueBitsPerPixel;		//!< Format blue bits per pixel.  0 for N/A.
	vlUInt	uiAlphaBitsPerPixel;	//!< Format alpha bits per pixel.  0 for N/A.
	vlBool	bIsCompressed;			//!< Format is compressed (DXT).
	vlBool	bIsSupported;			//!< Format is supported by VTFLib.
} SVTFImageFormatInfo;

typedef struct tagSVTFCreateOptions
{
	vlUInt uiVersion[2];								//!< Output image version.
	VTFImageFormat ImageFormat;							//!< Output image output storage format.

	vlUInt uiFlags;										//!< Output image header flags.
	vlUInt uiStartFrame;								//!< Output image start frame.
	vlSingle sBumpScale;								//!< Output image bump scale.
	vlSingle sReflectivity[3];							//!< Output image reflectivity. (Only used if bReflectivity is false.)

	vlBool bMipmaps;									//!< Generate MIPmaps. (Space is always allocated.)
	VTFMipmapFilter MipmapFilter;						//!< MIP map re-size filter.

	vlBool bThumbnail;									//!< Generate thumbnail image.
	vlBool bReflectivity;								//!< Compute image reflectivity.

	vlBool bResize;										//!< Resize the input image.
	VTFResizeMethod ResizeMethod;						//!< New size compution method.
	VTFMipmapFilter ResizeFilter;						//!< Re-size filter.
	vlUInt uiResizeWidth;								//!< New width after re-size if method is RESIZE_SET.
	vlUInt uiResizeHeight;								//!< New height after re-size if method is RESIZE_SET.

	vlBool bResizeClamp;								//!< Clamp re-size size.
	vlUInt uiResizeClampWidth;							//!< Maximum width to re-size to.
	vlUInt uiResizeClampHeight;							//!< Maximum height to re-size to.

	vlBool bGammaCorrection;							//!< Gamma correct input image.
	vlSingle sGammaCorrection;							//!< Gamma correction to apply.

	vlBool bSphereMap;									//!< Generate a sphere map for six faced environment maps.
	vlBool bSRGB;										//!< Texture is in the SRGB color space.
} SVTFCreateOptions;

typedef struct tagSVTFInitOptions
{
	vlUInt uiWidth;
	vlUInt uiHeight;
	vlUInt uiSlices;
	
	vlUInt uiFrames;
	vlUInt uiFaces;
	
	VTFImageFormat ImageFormat;
	
	vlBool bThumbnail;
	vlUInt nMipMaps;
	
	vlBool bNullImageData;
} SVTFInitOptions;


	class CVTFFile
	{
	public:
		CVTFFile();
		CVTFFile(const CVTFFile &VTFFile);
		CVTFFile(const CVTFFile &VTFFile, VTFImageFormat ImageFormat);
		~CVTFFile();
		
		vlBool Init(vlUInt uiWidth, vlUInt uiHeight, vlUInt uiFrames = 1, vlUInt uiFaces = 1, vlUInt uiSlices = 1, VTFImageFormat ImageFormat = IMAGE_FORMAT_RGBA8888, vlBool bThumbnail = vlTrue, vlInt nMipmaps = -1, vlBool bNullImageData = vlFalse);
		vlBool Init(const SVTFInitOptions& initOpts);
		vlBool Create(vlUInt uiWidth, vlUInt uiHeight, vlUInt uiFrames = 1, vlUInt uiFaces = 1, vlUInt uiSlices = 1, VTFImageFormat ImageFormat = IMAGE_FORMAT_RGBA8888, vlBool bThumbnail = vlTrue, vlBool bMipmaps = vlTrue, vlBool bNullImageData = vlFalse);
		vlBool Create(vlUInt uiWidth, vlUInt uiHeight, vlByte *lpImageDataRGBA8888, const SVTFCreateOptions &VTFCreateOptions);
		vlBool Create(vlUInt uiWidth, vlUInt uiHeight, vlUInt uiFrames, vlUInt uiFaces, vlUInt vlSlices, vlByte **lpImageDataRGBA8888, const SVTFCreateOptions &VTFCreateOptions);
		void Destroy();
		vlBool IsLoaded() const;
		vlBool Load(const vlChar *cFileName, vlBool bHeaderOnly = vlFalse);
		vlBool Load(const void *lpData, vlUInt uiBufferSize, vlBool bHeaderOnly = vlFalse);
		vlBool Load(void *pUserData, vlBool bHeaderOnly = vlFalse);
		vlBool Save(const vlChar *cFileName) const;
		vlBool Save(void *lpData, vlUInt uiBufferSize, vlUInt &uiSize) const;
		vlBool Save(void *pUserData) const;
		vlBool ConvertInPlace(VTFImageFormat format);
		vlBool GetHasImage() const;
		vlUInt GetMajorVersion() const;
		vlUInt GetMinorVersion() const;
		bool SetVersion(vlUInt major, vlUInt minor);
		vlUInt GetSize() const;
		vlUInt GetWidth() const;
		vlUInt GetHeight() const;
		vlUInt GetDepth() const;
		vlUInt GetFrameCount() const;
		vlUInt GetFaceCount() const;
		vlUInt GetMipmapCount() const;
		vlUInt GetStartFrame() const;
		void SetStartFrame(vlUInt uiStartFrame);
		vlUInt GetFlags() const;
		void SetFlags(vlUInt uiFlags);
		vlBool GetFlag(VTFImageFlag ImageFlag) const;
		void SetFlag(VTFImageFlag ImageFlag, vlBool bState);
		vlSingle GetBumpmapScale() const;
		void SetBumpmapScale(vlSingle sBumpmapScale);
		void GetReflectivity(vlSingle &sX, vlSingle &sY, vlSingle &sZ) const;
		void SetReflectivity(vlSingle sX, vlSingle sY, vlSingle sZ);
		VTFImageFormat GetFormat() const;
		vlByte *GetData(vlUInt uiFrame, vlUInt uiFace, vlUInt uiSlice, vlUInt uiMipmapLevel) const;
		void SetData(vlUInt uiFrame, vlUInt uiFace, vlUInt uiSlice, vlUInt uiMipmapLevel, vlByte *lpData);
		vlBool GetHasThumbnail() const;
		vlUInt GetThumbnailWidth() const;
		vlUInt GetThumbnailHeight() const;
		VTFImageFormat GetThumbnailFormat() const;
		vlByte *GetThumbnailData() const;
		void SetThumbnailData(vlByte *lpData);
		vlBool GetSupportsResources() const;
		vlUInt GetResourceCount() const;
		vlUInt GetResourceType(vlUInt uiIndex) const;
		vlBool GetHasResource(vlUInt uiType) const;
		void *GetResourceData(vlUInt uiType, vlUInt &uiSize) const;
		void *SetResourceData(vlUInt uiType, vlUInt uiSize, void *lpData);
		vlInt GetAuxCompressionLevel() const;
		vlBool SetAuxCompressionLevel(vlInt iCompressionLevel);
		vlBool GenerateMipmaps(VTFMipmapFilter MipmapFilter, vlBool bSRGB);
		vlBool GenerateMipmaps(vlUInt uiFace, vlUInt uiFrame, VTFMipmapFilter MipmapFilter, vlBool bSRGB);
		vlBool GenerateThumbnail(vlBool bSRGB);
		vlBool GenerateNormalMap(VTFKernelFilter KernelFilter = KERNEL_FILTER_3X3, VTFHeightConversionMethod HeightConversionMethod = HEIGHT_CONVERSION_METHOD_AVERAGE_RGB, VTFNormalAlphaResult NormalAlphaResult = NORMAL_ALPHA_RESULT_WHITE);
		vlBool GenerateNormalMap(vlUInt uiFrame, VTFKernelFilter KernelFilter = KERNEL_FILTER_3X3, VTFHeightConversionMethod HeightConversionMethod = HEIGHT_CONVERSION_METHOD_AVERAGE_RGB, VTFNormalAlphaResult NormalAlphaResult = NORMAL_ALPHA_RESULT_WHITE);
		vlBool GenerateSphereMap();
		vlBool ComputeReflectivity();
		static SVTFImageFormatInfo const &GetImageFormatInfo(VTFImageFormat ImageFormat);
		static vlUInt ComputeImageSize(vlUInt uiWidth, vlUInt uiHeight, vlUInt uiDepth, VTFImageFormat ImageFormat);
		static vlUInt ComputeImageSize(vlUInt uiWidth, vlUInt uiHeight, vlUInt uiDepth, vlUInt uiMipmaps, VTFImageFormat ImageFormat);
		static vlUInt ComputeMipmapCount(vlUInt uiWidth, vlUInt uiHeight, vlUInt uiDepth);
		static void ComputeMipmapDimensions(vlUInt uiWidth, vlUInt uiHeight, vlUInt uiDepth, vlUInt uiMipmapLevel, vlUInt &uiMipmapWidth, vlUInt &uiMipmapHeight, vlUInt &uiMipmapDepth);
		static vlUInt ComputeMipmapSize(vlUInt uiWidth, vlUInt uiHeight, vlUInt uiDepth, vlUInt uiMipmapLevel, VTFImageFormat ImageFormat);
		static vlBool ConvertToRGBA8888(vlByte *lpSource, vlByte *lpDest, vlUInt uiWidth, vlUInt uiHeight, VTFImageFormat SourceFormat);
		static vlBool ConvertFromRGBA8888(vlByte *lpSource, vlByte *lpDest, vlUInt uiWidth, vlUInt uiHeight, VTFImageFormat DestFormat);
		static vlBool Convert(vlByte *lpSource, vlByte *lpDest, vlUInt uiWidth, vlUInt uiHeight, VTFImageFormat SourceFormat, VTFImageFormat DestFormat);
		static vlBool Resize(vlByte *lpSourceRGBA8888, vlByte *lpDestRGBA8888, vlUInt uiSourceWidth, vlUInt uiSourceHeight, vlUInt uiDestWidth, vlUInt uiDestHeight, VTFMipmapFilter ResizeFilter, vlBool bSRGB);
		static void CorrectImageGamma(vlByte *lpImageDataRGBA8888, vlUInt uiWidth, vlUInt uiHeight, vlSingle sGammaCorrection);
		static void ComputeImageReflectivity(vlByte *lpImageDataRGBA8888, vlUInt uiWidth, vlUInt uiHeight, vlSingle &sX, vlSingle &sY, vlSingle &sZ);
		static void FlipImage(vlByte *lpImageDataRGBA8888, vlUInt uiWidth, vlUInt uiHeight);
		static void MirrorImage(vlByte *lpImageDataRGBA8888, vlUInt uiWidth, vlUInt uiHeight); 
	};
