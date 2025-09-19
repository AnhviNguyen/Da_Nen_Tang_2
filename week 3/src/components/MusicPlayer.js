import React from 'react';

const MusicPlayer = ({
  currentTrack,
  isPlaying,
  currentTime,
  duration,
  onPlay,
  onPause,
  onNext,
  onPrevious,
  onSeek
}) => {
  const formatTime = (seconds) => {
    if (!seconds || isNaN(seconds)) return '0:00';
    const mins = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  const progressPercentage = duration ? (currentTime / duration) * 100 : 0;

  return (
    <div className="audio-player rounded-lg p-6 shadow-2xl">
      <div className="flex items-center space-x-6">
        {/* Album Art Placeholder */}
        <div className="flex-shrink-0">
          <div className="w-20 h-20 bg-gradient-to-br from-primary-500 to-secondary-500 rounded-lg flex items-center justify-center shadow-lg">
            <span className="text-white text-2xl">🎵</span>
          </div>
        </div>

        {/* Track Info */}
        <div className="flex-1 min-w-0">
          <h3 className="text-white text-lg font-semibold truncate">
            {currentTrack.name.replace(/\.[^/.]+$/, '')}
          </h3>
          <p className="text-slate-300 text-sm">
            {formatTime(currentTime)} / {formatTime(duration)}
          </p>
        </div>

        {/* Controls */}
        <div className="flex items-center space-x-4">
          <button
            onClick={onPrevious}
            className="p-3 bg-slate-700 hover:bg-slate-600 text-white rounded-full transition-colors duration-200"
            title="Previous track"
          >
            ⏮️
          </button>
          
          <button
            onClick={isPlaying ? onPause : () => onPlay(currentTrack)}
            className="p-4 bg-primary-600 hover:bg-primary-700 text-white rounded-full transition-colors duration-200 shadow-lg"
            title={isPlaying ? 'Pause' : 'Play'}
          >
            {isPlaying ? '⏸️' : '▶️'}
          </button>
          
          <button
            onClick={onNext}
            className="p-3 bg-slate-700 hover:bg-slate-600 text-white rounded-full transition-colors duration-200"
            title="Next track"
          >
            ⏭️
          </button>
        </div>
      </div>

      {/* Progress Bar */}
      <div className="mt-6">
        <div
          className="w-full h-2 bg-slate-700 rounded-full cursor-pointer"
          onClick={onSeek}
        >
          <div
            className="progress-bar h-2 rounded-full transition-all duration-100 relative"
            style={{ width: `${progressPercentage}%` }}
          >
            <div className="absolute right-0 top-1/2 transform -translate-y-1/2 w-4 h-4 bg-white rounded-full shadow-lg"></div>
          </div>
        </div>
      </div>

      {/* Additional Info */}
      <div className="mt-4 flex items-center justify-between text-xs text-slate-400">
        <div className="flex items-center space-x-4">
          <span>🎧 Offline Mode</span>
          <span>🔒 Secure</span>
        </div>
        <div>
          {isPlaying ? '▶️ Playing' : '⏸️ Paused'}
        </div>
      </div>
    </div>
  );
};

export default MusicPlayer;
