%module VTFLib

%{
#include "VTFLib.h"
using namespace VTFLib;
%}

typedef struct tagSVTFImageFormatInfo
{
	const char *lpName;			//!< Enumeration text equivalent.
	unsigned int	uiBitsPerPixel;			//!< Format bits per pixel.
	unsigned int	uiBytesPerPixel;		//!< Format bytes per pixel.
	unsigned int	uiRedBitsPerPixel;		//!< Format red bits per pixel.  0 for N/A.
	unsigned int	uiGreenBitsPerPixel;	//!< Format green bits per pixel.  0 for N/A.
	unsigned int	uiBlueBitsPerPixel;		//!< Format blue bits per pixel.  0 for N/A.
	unsigned int	uiAlphaBitsPerPixel;	//!< Format alpha bits per pixel.  0 for N/A.
	bool	bIsCompressed;			//!< Format is compressed (DXT).
	bool	bIsSupported;			//!< Format is supported by VTFLib.
} SVTFImageFormatInfo;

typedef struct tagSVTFCreateOptions
{
	unsigned int uiVersion[2];								//!< Output image version.
	VTFImageFormat ImageFormat;							//!< Output image output storage format.

	unsigned int uiFlags;										//!< Output image header flags.
	unsigned int uiStartFrame;								//!< Output image start frame.
	float sBumpScale;								//!< Output image bump scale.
	float sReflectivity[3];							//!< Output image reflectivity. (Only used if bReflectivity is false.)

	bool bMipmaps;									//!< Generate MIPmaps. (Space is always allocated.)
	VTFMipmapFilter MipmapFilter;						//!< MIP map re-size filter.

	bool bThumbnail;									//!< Generate thumbnail image.
	bool bReflectivity;								//!< Compute image reflectivity.

	bool bResize;										//!< Resize the input image.
	VTFResizeMethod ResizeMethod;						//!< New size compution method.
	VTFMipmapFilter ResizeFilter;						//!< Re-size filter.
	unsigned int uiResizeWidth;								//!< New width after re-size if method is RESIZE_SET.
	unsigned int uiResizeHeight;								//!< New height after re-size if method is RESIZE_SET.

	bool bResizeClamp;								//!< Clamp re-size size.
	unsigned int uiResizeClampWidth;							//!< Maximum width to re-size to.
	unsigned int uiResizeClampHeight;							//!< Maximum height to re-size to.

	bool bGammaCorrection;							//!< Gamma correct input image.
	float sGammaCorrection;							//!< Gamma correction to apply.

	bool bSphereMap;									//!< Generate a sphere map for six faced environment maps.
	bool bSRGB;										//!< Texture is in the SRGB color space.
} SVTFCreateOptions;

typedef struct tagSVTFInitOptions
{
	unsigned int uiWidth;
	unsigned int uiHeight;
	unsigned int uiSlices;
	
	unsigned int uiFrames;
	unsigned int uiFaces;
	
	VTFImageFormat ImageFormat;
	
	bool bThumbnail;
	unsigned int nMipMaps;
	
	bool bNullImageData;
} SVTFInitOptions;


	class CVTFFile
	{
	public:
		CVTFFile();
		CVTFFile(const CVTFFile &VTFFile);
		CVTFFile(const CVTFFile &VTFFile, VTFImageFormat ImageFormat);
		~CVTFFile();
		
		bool Init(unsigned int uiWidth, unsigned int uiHeight, unsigned int uiFrames = 1, unsigned int uiFaces = 1, unsigned int uiSlices = 1, VTFImageFormat ImageFormat = IMAGE_FORMAT_RGBA8888, bool bThumbnail = true, int nMipmaps = -1, bool bNullImageData = false);
		bool Init(const SVTFInitOptions& initOpts);
		bool Create(unsigned int uiWidth, unsigned int uiHeight, unsigned int uiFrames = 1, unsigned int uiFaces = 1, unsigned int uiSlices = 1, VTFImageFormat ImageFormat = IMAGE_FORMAT_RGBA8888, bool bThumbnail = true, bool bMipmaps = true, bool bNullImageData = false);
		bool Create(unsigned int uiWidth, unsigned int uiHeight, unsigned char *lpImageDataRGBA8888, const SVTFCreateOptions &VTFCreateOptions);
		bool Create(unsigned int uiWidth, unsigned int uiHeight, unsigned int uiFrames, unsigned int uiFaces, unsigned int vlSlices, unsigned char **lpImageDataRGBA8888, const SVTFCreateOptions &VTFCreateOptions);
		void Destroy();
		bool IsLoaded() const;
		bool Load(const char *cFileName, bool bHeaderOnly = false);
		bool Load(const void *lpData, unsigned int uiBufferSize, bool bHeaderOnly = false);
		bool Load(void *pUserData, bool bHeaderOnly = false);
		bool Save(const char *cFileName) const;
		bool Save(void *lpData, unsigned int uiBufferSize, unsigned int &uiSize) const;
		bool Save(void *pUserData) const;
		bool ConvertInPlace(VTFImageFormat format);
		bool GetHasImage() const;
		unsigned int GetMajorVersion() const;
		unsigned int GetMinorVersion() const;
		bool SetVersion(unsigned int major, unsigned int minor);
		unsigned int GetSize() const;
		unsigned int GetWidth() const;
		unsigned int GetHeight() const;
		unsigned int GetDepth() const;
		unsigned int GetFrameCount() const;
		unsigned int GetFaceCount() const;
		unsigned int GetMipmapCount() const;
		unsigned int GetStartFrame() const;
		void SetStartFrame(unsigned int uiStartFrame);
		unsigned int GetFlags() const;
		void SetFlags(unsigned int uiFlags);
		bool GetFlag(VTFImageFlag ImageFlag) const;
		void SetFlag(VTFImageFlag ImageFlag, bool bState);
		float GetBumpmapScale() const;
		void SetBumpmapScale(float sBumpmapScale);
		void GetReflectivity(float &sX, float &sY, float &sZ) const;
		void SetReflectivity(float sX, float sY, float sZ);
		VTFImageFormat GetFormat() const;
		unsigned char *GetData(unsigned int uiFrame, unsigned int uiFace, unsigned int uiSlice, unsigned int uiMipmapLevel) const;
		void SetData(unsigned int uiFrame, unsigned int uiFace, unsigned int uiSlice, unsigned int uiMipmapLevel, unsigned char *lpData);
		bool GetHasThumbnail() const;
		unsigned int GetThumbnailWidth() const;
		unsigned int GetThumbnailHeight() const;
		VTFImageFormat GetThumbnailFormat() const;
		unsigned char *GetThumbnailData() const;
		void SetThumbnailData(unsigned char *lpData);
		bool GetSupportsResources() const;
		unsigned int GetResourceCount() const;
		unsigned int GetResourceType(unsigned int uiIndex) const;
		bool GetHasResource(unsigned int uiType) const;
		void *GetResourceData(unsigned int uiType, unsigned int &uiSize) const;
		void *SetResourceData(unsigned int uiType, unsigned int uiSize, void *lpData);
		int GetAuxCompressionLevel() const;
		bool SetAuxCompressionLevel(int iCompressionLevel);
		bool GenerateMipmaps(VTFMipmapFilter MipmapFilter, bool bSRGB);
		bool GenerateMipmaps(unsigned int uiFace, unsigned int uiFrame, VTFMipmapFilter MipmapFilter, bool bSRGB);
		bool GenerateThumbnail(bool bSRGB);
		bool GenerateNormalMap(VTFKernelFilter KernelFilter = KERNEL_FILTER_3X3, VTFHeightConversionMethod HeightConversionMethod = HEIGHT_CONVERSION_METHOD_AVERAGE_RGB, VTFNormalAlphaResult NormalAlphaResult = NORMAL_ALPHA_RESULT_WHITE);
		bool GenerateNormalMap(unsigned int uiFrame, VTFKernelFilter KernelFilter = KERNEL_FILTER_3X3, VTFHeightConversionMethod HeightConversionMethod = HEIGHT_CONVERSION_METHOD_AVERAGE_RGB, VTFNormalAlphaResult NormalAlphaResult = NORMAL_ALPHA_RESULT_WHITE);
		bool GenerateSphereMap();
		bool ComputeReflectivity();
		static SVTFImageFormatInfo const &GetImageFormatInfo(VTFImageFormat ImageFormat);
		static unsigned int ComputeImageSize(unsigned int uiWidth, unsigned int uiHeight, unsigned int uiDepth, VTFImageFormat ImageFormat);
		static unsigned int ComputeImageSize(unsigned int uiWidth, unsigned int uiHeight, unsigned int uiDepth, unsigned int uiMipmaps, VTFImageFormat ImageFormat);
		static unsigned int ComputeMipmapCount(unsigned int uiWidth, unsigned int uiHeight, unsigned int uiDepth);
		static void ComputeMipmapDimensions(unsigned int uiWidth, unsigned int uiHeight, unsigned int uiDepth, unsigned int uiMipmapLevel, unsigned int &uiMipmapWidth, unsigned int &uiMipmapHeight, unsigned int &uiMipmapDepth);
		static unsigned int ComputeMipmapSize(unsigned int uiWidth, unsigned int uiHeight, unsigned int uiDepth, unsigned int uiMipmapLevel, VTFImageFormat ImageFormat);
		static bool ConvertToRGBA8888(unsigned char *lpSource, unsigned char *lpDest, unsigned int uiWidth, unsigned int uiHeight, VTFImageFormat SourceFormat);
		static bool ConvertFromRGBA8888(unsigned char *lpSource, unsigned char *lpDest, unsigned int uiWidth, unsigned int uiHeight, VTFImageFormat DestFormat);
		static bool Convert(unsigned char *lpSource, unsigned char *lpDest, unsigned int uiWidth, unsigned int uiHeight, VTFImageFormat SourceFormat, VTFImageFormat DestFormat);
		static bool Resize(unsigned char *lpSourceRGBA8888, unsigned char *lpDestRGBA8888, unsigned int uiSourceWidth, unsigned int uiSourceHeight, unsigned int uiDestWidth, unsigned int uiDestHeight, VTFMipmapFilter ResizeFilter, bool bSRGB);
		static void CorrectImageGamma(unsigned char *lpImageDataRGBA8888, unsigned int uiWidth, unsigned int uiHeight, float sGammaCorrection);
		static void ComputeImageReflectivity(unsigned char *lpImageDataRGBA8888, unsigned int uiWidth, unsigned int uiHeight, float &sX, float &sY, float &sZ);
		static void FlipImage(unsigned char *lpImageDataRGBA8888, unsigned int uiWidth, unsigned int uiHeight);
		static void MirrorImage(unsigned char *lpImageDataRGBA8888, unsigned int uiWidth, unsigned int uiHeight); 
	};
