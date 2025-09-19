import React, { useRef } from 'react';

const FileUpload = ({ onFileUpload }) => {
  const fileInputRef = useRef(null);

  const handleFileSelect = (e) => {
    const files = Array.from(e.target.files);
    const mediaFiles = files.filter(file => 
      file.type.startsWith('audio/') || 
      file.type.startsWith('video/') ||
      file.name.match(/\.(mp3|wav|ogg|m4a|flac|aac|mp4|avi|mov|mkv|webm)$/i)
    );
    
    if (mediaFiles.length > 0) {
      onFileUpload(mediaFiles);
    } else {
      alert('Please select valid media files (mp3, wav, ogg, m4a, flac, aac, mp4, avi, mov, mkv, webm)');
    }
    
    // Reset file input
    e.target.value = '';
  };

  const handleDrop = (e) => {
    e.preventDefault();
    const files = Array.from(e.dataTransfer.files);
    const mediaFiles = files.filter(file => 
      file.type.startsWith('audio/') || 
      file.type.startsWith('video/') ||
      file.name.match(/\.(mp3|wav|ogg|m4a|flac|aac|mp4|avi|mov|mkv|webm)$/i)
    );
    
    if (mediaFiles.length > 0) {
      onFileUpload(mediaFiles);
    } else {
      alert('Please drop valid media files (mp3, wav, ogg, m4a, flac, aac, mp4, avi, mov, mkv, webm)');
    }
  };

  const handleDragOver = (e) => {
    e.preventDefault();
  };

  const formatFileSize = (bytes) => {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
  };

  return (
    <div className="bg-slate-800 rounded-lg p-6 border border-slate-700">
      <h2 className="text-xl font-semibold text-white mb-4 flex items-center">
        <span className="mr-2">📁</span>
        Upload Media Files
      </h2>
      
      <div
        className="upload-area rounded-lg p-8 text-center cursor-pointer transition-all duration-300"
        onClick={() => fileInputRef.current?.click()}
        onDrop={handleDrop}
        onDragOver={handleDragOver}
      >
        <div className="text-slate-300">
          <div className="text-4xl mb-4">🎵🎬</div>
          <p className="text-lg font-medium mb-2">
            Drop your media files here
          </p>
          <p className="text-sm text-slate-400 mb-4">
            or click to browse files
          </p>
          <p className="text-xs text-slate-500">
            Audio: MP3, WAV, OGG, M4A, FLAC, AAC<br/>
            Video: MP4, AVI, MOV, MKV, WEBM
          </p>
        </div>
      </div>

      <input
        ref={fileInputRef}
        type="file"
        multiple
        accept="audio/*,video/*,.mp3,.wav,.ogg,.m4a,.flac,.aac,.mp4,.avi,.mov,.mkv,.webm"
        onChange={handleFileSelect}
        className="hidden"
      />

      <div className="mt-4 text-xs text-slate-400">
        <p>💡 Files are cached locally for offline playback</p>
        <p>🔒 Your media stays on your device</p>
        <p>🎬 Supports both audio and video files</p>
      </div>
    </div>
  );
};

export default FileUpload;
