import React from 'react';

const MusicLibrary = ({ musicFiles, currentTrack, onPlay, onDelete }) => {
  const formatFileSize = (bytes) => {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
  };

  const formatDuration = (seconds) => {
    if (!seconds || isNaN(seconds)) return '0:00';
    const mins = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };


  const getFileType = (file) => {
    return file.mediaType || (file.type.startsWith('video/') ? 'video' : 'audio');
  };

  const getFileIcon = (file) => {
    const type = getFileType(file);
    return type === 'video' ? '🎬' : '🎵';
  };

  if (musicFiles.length === 0) {
    return (
      <div className="bg-slate-800 rounded-lg p-6 border border-slate-700">
        <h2 className="text-xl font-semibold text-white mb-4 flex items-center">
          <span className="mr-2">🎶</span>
          Media Library
        </h2>
        <div className="text-center py-12">
          <div className="text-6xl mb-4">🎵🎬</div>
          <p className="text-slate-300 text-lg mb-2">No media files yet</p>
          <p className="text-slate-400 text-sm">
            Upload some audio or video files to get started
          </p>
        </div>
      </div>
    );
  }

  return (
    <div className="bg-slate-800 rounded-lg p-6 border border-slate-700">
      <h2 className="text-xl font-semibold text-white mb-4 flex items-center">
        <span className="mr-2">🎶</span>
        Media Library ({musicFiles.length} files)
      </h2>
      
      <div className="space-y-2 max-h-96 overflow-y-auto">
        {musicFiles.map((track) => (
          <div
            key={track.id}
            className={`music-card p-4 rounded-lg border transition-all duration-300 ${
              currentTrack && currentTrack.id === track.id
                ? getFileType(track) === 'video' 
                  ? 'bg-secondary-600 border-secondary-400 shadow-lg shadow-secondary-500/20'
                  : 'bg-primary-600 border-primary-400 shadow-lg shadow-primary-500/20'
                : 'bg-slate-700 border-slate-600 hover:bg-slate-600'
            }`}
          >
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-4 flex-1 min-w-0">
                <div className="flex-shrink-0">
                  {currentTrack && currentTrack.id === track.id ? (
                    <div className={`w-12 h-12 rounded-full flex items-center justify-center ${
                      getFileType(track) === 'video' ? 'bg-secondary-500' : 'bg-primary-500'
                    }`}>
                      <span className="text-white text-xl">{getFileIcon(track)}</span>
                    </div>
                  ) : (
                    <div className="w-12 h-12 bg-slate-600 rounded-full flex items-center justify-center">
                      <span className="text-slate-300 text-xl">{getFileIcon(track)}</span>
                    </div>
                  )}
                </div>
                
                <div className="flex-1 min-w-0">
                  <h3 className="text-white font-medium truncate">
                    {track.name.replace(/\.[^/.]+$/, '')}
                  </h3>
                  <div className="flex items-center space-x-4 text-sm text-slate-400">
                    <span>{formatFileSize(track.size)}</span>
                    <span>•</span>
                    <span>{track.type}</span>
                    <span>•</span>
                    <span className={`px-2 py-1 rounded text-xs ${
                      getFileType(track) === 'video' 
                        ? 'bg-secondary-500/20 text-secondary-300' 
                        : 'bg-primary-500/20 text-primary-300'
                    }`}>
                      {getFileType(track) === 'video' ? '🎬 Video' : '🎵 Audio'}
                    </span>
                  </div>
                </div>
              </div>
              
              <div className="flex items-center space-x-2">
                <button
                  onClick={() => onPlay(track)}
                  className={`px-4 py-2 text-white rounded-lg transition-colors duration-200 flex items-center space-x-2 ${
                    getFileType(track) === 'video'
                      ? 'bg-secondary-600 hover:bg-secondary-700'
                      : 'bg-primary-600 hover:bg-primary-700'
                  }`}
                >
                  <span>
                    {currentTrack && currentTrack.id === track.id ? '▶️' : '▶️'}
                  </span>
                  <span className="hidden sm:inline">
                    {currentTrack && currentTrack.id === track.id ? 'Playing' : 'Play'}
                  </span>
                </button>
                
                <button
                  onClick={() => onDelete(track.id)}
                  className="px-3 py-2 bg-red-600 hover:bg-red-700 text-white rounded-lg transition-colors duration-200"
                  title="Delete track"
                >
                  🗑️
                </button>
              </div>
            </div>
          </div>
        ))}
      </div>
      
      <div className="mt-4 text-xs text-slate-400">
        <p>💾 {musicFiles.length} media files cached for offline playback</p>
        <p>🎵 Audio: {musicFiles.filter(f => getFileType(f) === 'audio').length} files</p>
        <p>🎬 Video: {musicFiles.filter(f => getFileType(f) === 'video').length} files</p>
      </div>
    </div>
  );
};

export default MusicLibrary;
