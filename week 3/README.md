# 🎵🎬 Media Player Offline

A Progressive Web App (PWA) for playing audio and video files offline. Upload your media files and enjoy them without an internet connection.

## ✨ Features

- **Offline Media Playback**: Upload and play audio and video files without internet connection
- **PWA Support**: Install as a native app on your device
- **File Upload**: Drag & drop or click to upload media files
- **Media Library**: Organize and manage your uploaded tracks
- **Responsive Design**: Works on desktop and mobile devices
- **Local Storage**: Media files are cached locally for offline access
- **Modern UI**: Beautiful interface with black, white, blue, and green color scheme
- **Dual Player**: Separate interfaces for audio and video playback

## 🎨 Supported Media Formats

### Audio Formats:
- MP3
- WAV
- OGG
- M4A
- FLAC
- AAC

### Video Formats:
- MP4
- AVI
- MOV
- MKV
- WEBM

## 🚀 Getting Started

### Prerequisites

- Node.js (version 14 or higher)
- npm or yarn

### Installation

1. Clone or download this project
2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the development server:
   ```bash
   npm start
   ```

4. Open [http://localhost:3000](http://localhost:3000) to view it in the browser

### Building for Production

```bash
npm run build
```

This builds the app for production to the `build` folder and includes PWA functionality.

## 📱 PWA Installation

1. Open the app in a supported browser (Chrome, Edge, Safari, Firefox)
2. Look for the "Install" button in the address bar or browser menu
3. Click "Install" to add the app to your home screen
4. The app will work offline after installation

## 🎵🎬 How to Use

1. **Upload Media**: 
   - Drag and drop audio or video files onto the upload area
   - Or click the upload area to browse and select files

2. **Play Media**:
   - Click the play button next to any track in the library
   - Use the media player controls to play, pause, skip tracks
   - Audio files use the music player interface
   - Video files use the video player interface

3. **Manage Library**:
   - View all uploaded tracks in the media library
   - See file type indicators (🎵 Audio / 🎬 Video)
   - Delete tracks you no longer want
   - Tracks are automatically saved for offline use

## 🔧 Technical Details

- **Frontend**: React 18 with Hooks
- **Styling**: Tailwind CSS
- **PWA**: Service Worker for offline functionality
- **Storage**: LocalStorage for track metadata
- **Caching**: Cache API for media files
- **Media Support**: HTML5 Audio and Video elements

## 🎨 Color Scheme

- **Primary Blue**: #0ea5e9 (buttons, accents)
- **Secondary Green**: #22c55e (progress bars, highlights)
- **Background**: Dark slate gradients (#0f172a to #1e293b)
- **Text**: White and light gray for contrast

## 📱 Browser Support

- Chrome (recommended)
- Firefox
- Safari
- Edge

## 🔒 Privacy

- All media files are stored locally on your device
- No data is sent to external servers
- Your media library remains private

## 🐛 Troubleshooting

- **Files not uploading**: Make sure you're using supported audio or video formats
- **PWA not installing**: Ensure you're using a supported browser
- **Media not playing**: Check if your browser supports the media format
- **Video not displaying**: Some browsers may have limited video codec support

## 📄 License

This project is open source and available under the MIT License.
