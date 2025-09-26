import React, { useState, useEffect, useMemo, useRef } from 'react';

// Leaflet Map Component
const LeafletMap = ({ center, zoom, notes, currentLocation, onDeleteNote, onOpenMaps, categories }) => {
  const mapRef = useRef(null);
  const mapInstanceRef = useRef(null);
  const markersRef = useRef([]);

  useEffect(() => {
    if (!mapRef.current) return;

    // Load Leaflet CSS and JS
    const loadLeaflet = async () => {
      // Load CSS
      if (!document.querySelector('link[href*="leaflet"]')) {
        const link = document.createElement('link');
        link.rel = 'stylesheet';
        link.href = 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/leaflet.min.css';
        document.head.appendChild(link);
      }

      // Load JS
      if (!window.L) {
        const script = document.createElement('script');
        script.src = 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/leaflet.min.js';
        script.onload = initMap;
        document.head.appendChild(script);
      } else {
        initMap();
      }
    };

    const initMap = () => {
      if (mapInstanceRef.current) {
        mapInstanceRef.current.remove();
      }

      // Create map
      const map = window.L.map(mapRef.current, {
        center: center,
        zoom: zoom,
        zoomControl: true,
      });

      // Add tile layer
      window.L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
      }).addTo(map);

      mapInstanceRef.current = map;

      // Custom icons for different categories
      const createIcon = (category, isCurrentLocation = false) => {
        if (isCurrentLocation) {
          return window.L.divIcon({
            className: 'custom-marker current-location',
            html: `<div style="
              width: 20px; 
              height: 20px; 
              border-radius: 50%; 
              background: #3b82f6; 
              border: 3px solid white; 
              box-shadow: 0 2px 6px rgba(0,0,0,0.3);
              animation: pulse 2s infinite;
            "></div>`,
            iconSize: [20, 20],
            iconAnchor: [10, 10]
          });
        }

        const colors = {
          work: '#2563eb',
          personal: '#16a34a', 
          travel: '#9333ea',
          food: '#ea580c',
          shopping: '#dc2626',
          other: '#4b5563'
        };

        return window.L.divIcon({
          className: 'custom-marker',
          html: `<div style="
            width: 32px; 
            height: 32px; 
            border-radius: 50% 50% 50% 0; 
            background: ${colors[category] || '#4b5563'}; 
            border: 2px solid white; 
            box-shadow: 0 2px 6px rgba(0,0,0,0.3);
            transform: rotate(-45deg);
            display: flex;
            align-items: center;
            justify-content: center;
          ">
            <span style="transform: rotate(45deg); font-size: 14px;">
              ${categories.find(c => c.id === category)?.icon || '📌'}
            </span>
          </div>`,
          iconSize: [32, 32],
          iconAnchor: [16, 32],
          popupAnchor: [0, -32]
        });
      };

      // Clear existing markers
      markersRef.current.forEach(marker => map.removeLayer(marker));
      markersRef.current = [];

      // Add current location marker
      if (currentLocation) {
        const currentMarker = window.L.marker([currentLocation.lat, currentLocation.lng], {
          icon: createIcon(null, true)
        }).addTo(map);

        const popupContent = `
          <div style="padding: 8px;">
            <h4 style="margin: 0 0 8px 0; color: #3b82f6; font-weight: bold;">📍 Vị trí hiện tại</h4>
            <p style="margin: 0; font-size: 12px; color: #666;">
              ${currentLocation.lat.toFixed(6)}, ${currentLocation.lng.toFixed(6)}
            </p>
            <p style="margin: 4px 0 0 0; font-size: 11px; color: #999;">
              Độ chính xác: ±${currentLocation.accuracy.toFixed(0)}m
            </p>
          </div>
        `;

        currentMarker.bindPopup(popupContent);
        markersRef.current.push(currentMarker);
      }

      // Add note markers
      notes.forEach(note => {
        const category = categories.find(c => c.id === note.category);
        const marker = window.L.marker([note.lat, note.lng], {
          icon: createIcon(note.category)
        }).addTo(map);

        const distance = currentLocation ? 
          Math.round(calculateDistance(currentLocation.lat, currentLocation.lng, note.lat, note.lng)) : null;

        const popupContent = `
          <div style="padding: 12px; max-width: 250px;">
            <div style="display: flex; align-items: start; gap: 8px; margin-bottom: 12px;">
              <div style="
                width: 24px; 
                height: 24px; 
                background: ${category?.color?.replace('bg-', '#') || '#4b5563'}; 
                border-radius: 8px; 
                display: flex; 
                align-items: center; 
                justify-content: center;
                flex-shrink: 0;
              ">
                <span style="color: white; font-size: 12px;">${category?.icon}</span>
              </div>
              <div style="flex: 1;">
                <h4 style="margin: 0 0 4px 0; font-weight: bold; color: #1f2937; font-size: 14px;">
                  ${note.text}
                </h4>
                <p style="margin: 0; font-size: 11px; color: #6b7280;">${category?.name}</p>
              </div>
            </div>
            
            <div style="font-size: 11px; color: #6b7280; margin-bottom: 12px;">
              <div style="margin-bottom: 2px;">📍 ${note.address}</div>
              <div style="margin-bottom: 2px;">🕒 ${new Date(note.timestamp).toLocaleString('vi-VN')}</div>
              <div style="margin-bottom: 2px;">🎯 ${note.lat.toFixed(4)}, ${note.lng.toFixed(4)}</div>
              ${distance ? `<div style="color: #3b82f6; font-weight: 500;">📏 Cách ${distance >= 1000 ? `${(distance/1000).toFixed(1)}km` : `${distance}m`}</div>` : ''}
            </div>
            
            <div style="display: flex; gap: 6px;">
              <button 
                onclick="window.openInMaps(${note.lat}, ${note.lng}, '${note.address.replace(/'/g, "\\'")}')"
                style="
                  background: #3b82f6; 
                  color: white; 
                  border: none; 
                  padding: 6px 10px; 
                  border-radius: 6px; 
                  font-size: 11px; 
                  cursor: pointer;
                  flex: 1;
                "
                onmouseover="this.style.background='#2563eb'"
                onmouseout="this.style.background='#3b82f6'"
              >
                🗺️ Dẫn đường
              </button>
              <button 
                onclick="window.deleteNote(${note.id})"
                style="
                  background: #ef4444; 
                  color: white; 
                  border: none; 
                  padding: 6px 8px; 
                  border-radius: 6px; 
                  font-size: 11px; 
                  cursor: pointer;
                "
                onmouseover="this.style.background='#dc2626'"
                onmouseout="this.style.background='#ef4444'"
              >
                🗑️
              </button>
            </div>
          </div>
        `;

        marker.bindPopup(popupContent);
        markersRef.current.push(marker);
      });

      // Fit bounds to show all markers
      if (markersRef.current.length > 0) {
        const group = new window.L.featureGroup(markersRef.current);
        map.fitBounds(group.getBounds().pad(0.1));
      }
    };

    // Make functions globally available for popup buttons
    window.openInMaps = onOpenMaps;
    window.deleteNote = onDeleteNote;

    loadLeaflet();

    return () => {
      if (mapInstanceRef.current) {
        mapInstanceRef.current.remove();
      }
    };
  }, [center, notes, currentLocation]);

  // Add pulse animation CSS
  useEffect(() => {
    if (!document.querySelector('#pulse-animation')) {
      const style = document.createElement('style');
      style.id = 'pulse-animation';
      style.textContent = `
        @keyframes pulse {
          0% {
            box-shadow: 0 0 0 0 rgba(59, 130, 246, 0.7);
          }
          70% {
            box-shadow: 0 0 0 10px rgba(59, 130, 246, 0);
          }
          100% {
            box-shadow: 0 0 0 0 rgba(59, 130, 246, 0);
          }
        }
        .custom-marker {
          background: transparent !important;
          border: none !important;
        }
      `;
      document.head.appendChild(style);
    }
  }, []);

  const calculateDistance = (lat1, lng1, lat2, lng2) => {
    const R = 6371e3;
    const φ1 = lat1 * Math.PI/180;
    const φ2 = lat2 * Math.PI/180;
    const Δφ = (lat2-lat1) * Math.PI/180;
    const Δλ = (lng2-lng1) * Math.PI/180;

    const a = Math.sin(Δφ/2) * Math.sin(Δφ/2) +
              Math.cos(φ1) * Math.cos(φ2) *
              Math.sin(Δλ/2) * Math.sin(Δλ/2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));

    return R * c;
  };

  return (
    <div 
      ref={mapRef} 
      style={{ height: '500px', width: '100%', borderRadius: '12px', overflow: 'hidden' }}
      className="shadow-lg"
    />
  );
};

function App() {
  const [notes, setNotes] = useState([]);
  const [newNote, setNewNote] = useState('');
  const [currentLocation, setCurrentLocation] = useState(null);
  const [isLoading, setIsLoading] = useState(false);
  const [filterRadius, setFilterRadius] = useState(1000);
  const [showMap, setShowMap] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('all');
  const [sortBy, setSortBy] = useState('newest');
  const [showFilters, setShowFilters] = useState(false);
  const [locationError, setLocationError] = useState(null);
  const [isGettingLocation, setIsGettingLocation] = useState(false);

  // Categories for notes
  const categories = [
    { id: 'all', name: 'Tất cả', icon: '📝', color: 'bg-gray-500' },
    { id: 'work', name: 'Công việc', icon: '💼', color: 'bg-blue-600' },
    { id: 'personal', name: 'Cá nhân', icon: '👤', color: 'bg-green-600' },
    { id: 'travel', name: 'Du lịch', icon: '✈️', color: 'bg-purple-600' },
    { id: 'food', name: 'Ẩm thực', icon: '🍽️', color: 'bg-orange-600' },
    { id: 'shopping', name: 'Mua sắm', icon: '🛍️', color: 'bg-pink-600' },
    { id: 'other', name: 'Khác', icon: '📌', color: 'bg-gray-600' }
  ];

  // Load notes from memory (since localStorage is not supported)
  useEffect(() => {
    // Initialize with some sample data for demo
    const sampleNotes = [
      {
        id: 1,
        text: "Quán café ngon gần công ty",
        lat: 21.0285,
        lng: 105.8542,
        accuracy: 10,
        timestamp: new Date(Date.now() - 1000 * 60 * 30).toISOString(),
        address: "Hoàn Kiếm, Hà Nội",
        category: 'food'
      },
      {
        id: 2,
        text: "Họp khách hàng tại tòa nhà ABC",
        lat: 21.0245,
        lng: 105.8412,
        accuracy: 5,
        timestamp: new Date(Date.now() - 1000 * 60 * 60 * 2).toISOString(),
        address: "Ba Đình, Hà Nội",
        category: 'work'
      }
    ];
    setNotes(sampleNotes);
  }, []);

  const calculateDistance = (lat1, lng1, lat2, lng2) => {
    const R = 6371e3; // Earth's radius in meters
    const φ1 = lat1 * Math.PI/180;
    const φ2 = lat2 * Math.PI/180;
    const Δφ = (lat2-lat1) * Math.PI/180;
    const Δλ = (lng2-lng1) * Math.PI/180;

    const a = Math.sin(Δφ/2) * Math.sin(Δφ/2) +
              Math.cos(φ1) * Math.cos(φ2) *
              Math.sin(Δλ/2) * Math.sin(Δλ/2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));

    return R * c;
  };

  const getCurrentPosition = async () => {
    try {
      setIsGettingLocation(true);
      setLocationError(null);
      
      // Check if geolocation is supported
      if (!navigator.geolocation) {
        throw new Error('Geolocation không được hỗ trợ trên trình duyệt này');
      }

      const position = await new Promise((resolve, reject) => {
        navigator.geolocation.getCurrentPosition(
          resolve,
          reject,
          {
            enableHighAccuracy: true,
            timeout: 15000,
            maximumAge: 60000 // 1 minute cache
          }
        );
      });
      
      const location = {
        lat: position.coords.latitude,
        lng: position.coords.longitude,
        accuracy: position.coords.accuracy
      };
      
      setCurrentLocation(location);
      setLocationError(null);
      return location;
    } catch (error) {
      let errorMessage = 'Không thể lấy vị trí hiện tại';
      
      switch(error.code) {
        case error.PERMISSION_DENIED:
          errorMessage = 'Người dùng từ chối chia sẻ vị trí';
          break;
        case error.POSITION_UNAVAILABLE:
          errorMessage = 'Thông tin vị trí không khả dụng';
          break;
        case error.TIMEOUT:
          errorMessage = 'Yêu cầu lấy vị trí đã hết thời gian chờ';
          break;
        default:
          errorMessage = error.message || 'Lỗi không xác định khi lấy vị trí';
          break;
      }
      
      setLocationError(errorMessage);
      console.error('Error getting location:', error);
      return null;
    } finally {
      setIsGettingLocation(false);
    }
  };

  const getAddressFromCoordinates = async (lat, lng) => {
    try {
      const response = await fetch(
        `https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=${lat}&longitude=${lng}&localityLanguage=vi`
      );
      const data = await response.json();
      return data.localityInfo?.administrative?.[0]?.name || 
             data.locality || 
             data.city || 
             `${lat.toFixed(4)}, ${lng.toFixed(4)}`;
    } catch (error) {
      console.error('Error getting address:', error);
      return `${lat.toFixed(4)}, ${lng.toFixed(4)}`;
    }
  };

  const handleCheckIn = async (category = 'other') => {
    if (!newNote.trim()) {
      alert('Vui lòng nhập nội dung ghi chú');
      return;
    }

    setIsLoading(true);
    
    try {
      const location = await getCurrentPosition();
      if (!location) {
        setIsLoading(false);
        return;
      }

      const note = {
        id: Date.now(),
        text: newNote,
        lat: location.lat,
        lng: location.lng,
        accuracy: location.accuracy,
        timestamp: new Date().toISOString(),
        address: 'Đang tải địa chỉ...',
        category: category
      };

      setNotes(prev => [note, ...prev]);
      setNewNote('');
      
      // Get address asynchronously
      const address = await getAddressFromCoordinates(location.lat, location.lng);
      setNotes(prev => prev.map(n => 
        n.id === note.id ? { ...n, address } : n
      ));
      
    } catch (error) {
      console.error('Error creating note:', error);
      alert('Có lỗi xảy ra khi tạo ghi chú');
    } finally {
      setIsLoading(false);
    }
  };

  const deleteNote = (id) => {
    if (confirm('Bạn có chắc chắn muốn xóa ghi chú này?')) {
      setNotes(prev => prev.filter(note => note.id !== id));
    }
  };

  const openInMaps = (lat, lng, address = '') => {
    const isIOS = /iPad|iPhone|iPod/.test(navigator.userAgent);
    const isAndroid = /Android/.test(navigator.userAgent);
    
    let url;
    if (isIOS) {
      url = `http://maps.apple.com/?q=${encodeURIComponent(address || `${lat},${lng}`)}&ll=${lat},${lng}`;
    } else if (isAndroid) {
      url = `geo:${lat},${lng}?q=${lat},${lng}(${encodeURIComponent(address || 'Ghi chú')})`;
    } else {
      url = `https://www.google.com/maps?q=${lat},${lng}&zoom=15`;
    }
    
    window.open(url, '_blank');
  };

  // Advanced filtering and sorting
  const filteredAndSortedNotes = useMemo(() => {
    let filtered = notes.filter(note => {
      // Search filter
      if (searchTerm && !note.text.toLowerCase().includes(searchTerm.toLowerCase()) && 
          !note.address.toLowerCase().includes(searchTerm.toLowerCase())) {
        return false;
      }
      
      // Category filter
      if (selectedCategory !== 'all' && note.category !== selectedCategory) {
        return false;
      }
      
      // Distance filter
      if (currentLocation) {
        const distance = calculateDistance(
          currentLocation.lat,
          currentLocation.lng,
          note.lat,
          note.lng
        );
        return distance <= filterRadius;
      }
      
      return true;
    });

    // Sort notes
    filtered.sort((a, b) => {
      switch (sortBy) {
        case 'newest':
          return new Date(b.timestamp) - new Date(a.timestamp);
        case 'oldest':
          return new Date(a.timestamp) - new Date(b.timestamp);
        case 'distance': {
          if (!currentLocation) return 0;
          const distA = calculateDistance(currentLocation.lat, currentLocation.lng, a.lat, a.lng);
          const distB = calculateDistance(currentLocation.lat, currentLocation.lng, b.lat, b.lng);
          return distA - distB;
        }
        default:
          return 0;
      }
    });

    return filtered;
  }, [notes, searchTerm, selectedCategory, currentLocation, filterRadius, sortBy]);

  // Export data
  const handleExport = () => {
    const dataStr = JSON.stringify(notes, null, 2);
    const dataUri = 'data:application/json;charset=utf-8,'+ encodeURIComponent(dataStr);
    const exportFileDefaultName = `geo-notes-${new Date().toISOString().split('T')[0]}.json`;
    
    const linkElement = document.createElement('a');
    linkElement.setAttribute('href', dataUri);
    linkElement.setAttribute('download', exportFileDefaultName);
    linkElement.click();
  };

  // Import data
  const handleImport = (event) => {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (e) => {
        try {
          const importedNotes = JSON.parse(e.target.result);
          if (Array.isArray(importedNotes) && importedNotes.every(note => 
            note.id && note.text && note.lat && note.lng && note.timestamp
          )) {
            setNotes(importedNotes);
            alert('Import thành công!');
          } else {
            throw new Error('Invalid format');
          }
        } catch (error) {
          alert('File không hợp lệ! Vui lòng chọn file JSON đúng định dạng.');
        }
      };
      reader.readAsText(file);
    }
  };

  // Get map center
  const getMapCenter = () => {
    if (filteredAndSortedNotes.length > 0) {
      return [filteredAndSortedNotes[0].lat, filteredAndSortedNotes[0].lng];
    }
    if (currentLocation) {
      return [currentLocation.lat, currentLocation.lng];
    }
    return [21.0285, 105.8542]; // Default to Hanoi
  };

  // Auto-get location on first load
  useEffect(() => {
    getCurrentPosition();
  }, []);

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-900 via-blue-900 to-slate-800">
      {/* Header */}
      <header className="sticky top-0 z-50 bg-black/90 backdrop-blur-md border-b border-blue-500/30">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <div className="flex items-center space-x-4">
              <div className="w-10 h-10 bg-gradient-to-r from-blue-500 to-blue-600 rounded-xl flex items-center justify-center">
                <span className="text-white text-xl font-bold">📍</span>
              </div>
              <div>
                <h1 className="text-2xl font-bold bg-gradient-to-r from-blue-400 to-white bg-clip-text text-transparent">
                  Geo-Notes
                </h1>
                <p className="text-xs text-slate-400">Smart location-based notes</p>
              </div>
            </div>
            
            <div className="flex items-center space-x-3">
              <div className="hidden sm:flex items-center space-x-2 bg-slate-800/50 rounded-full px-4 py-2">
                <div className="w-2 h-2 bg-green-500 rounded-full animate-pulse"></div>
                <span className="text-slate-300 text-sm">{notes.length} ghi chú</span>
              </div>
              {currentLocation && (
                <div className="hidden md:flex items-center space-x-2 bg-blue-600/20 rounded-full px-3 py-1">
                  <span className="text-xs text-blue-300">📍 Vị trí đã lấy</span>
                </div>
              )}
            </div>
          </div>
        </div>
      </header>

      {/* Location Error Alert */}
      {locationError && (
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pt-4">
          <div className="bg-red-500/90 backdrop-blur-sm border border-red-400 text-white px-4 py-3 rounded-lg">
            <div className="flex items-center space-x-2">
              <span>⚠️</span>
              <span className="font-medium">Lỗi vị trí: </span>
              <span>{locationError}</span>
              <button 
                onClick={getCurrentPosition}
                className="ml-auto bg-white/20 hover:bg-white/30 px-3 py-1 rounded text-sm"
              >
                Thử lại
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Quick Actions */}
        <div className="mb-8">
          <div className="flex flex-wrap gap-3 justify-center sm:justify-start">
            <button
              onClick={() => setShowFilters(!showFilters)}
              className="flex items-center space-x-2 bg-white/10 hover:bg-white/20 text-white px-4 py-2 rounded-lg transition-all duration-200 backdrop-blur-sm border border-white/10"
            >
              <span>🔍</span>
              <span className="hidden sm:inline">{showFilters ? 'Ẩn bộ lọc' : 'Bộ lọc'}</span>
            </button>
            <button
              onClick={() => getCurrentPosition()}
              disabled={isGettingLocation}
              className="flex items-center space-x-2 bg-blue-600 hover:bg-blue-700 disabled:bg-blue-400 text-white px-4 py-2 rounded-lg transition-all duration-200"
            >
              <span>{isGettingLocation ? '⏳' : '📍'}</span>
              <span className="hidden sm:inline">
                {isGettingLocation ? 'Đang lấy...' : 'Cập nhật vị trí'}
              </span>
            </button>
            <button
              onClick={handleExport}
              className="flex items-center space-x-2 bg-white/10 hover:bg-white/20 text-white px-4 py-2 rounded-lg transition-all duration-200 backdrop-blur-sm border border-white/10"
            >
              <span>📤</span>
              <span className="hidden sm:inline">Xuất dữ liệu</span>
            </button>
            <label className="flex items-center space-x-2 bg-white/10 hover:bg-white/20 text-white px-4 py-2 rounded-lg transition-all duration-200 backdrop-blur-sm border border-white/10 cursor-pointer">
              <span>📥</span>
              <span className="hidden sm:inline">Nhập dữ liệu</span>
              <input
                type="file"
                accept=".json"
                onChange={handleImport}
                className="hidden"
              />
            </label>
          </div>
        </div>

        {/* Advanced Filters */}
        {showFilters && (
          <div className="mb-8 bg-white/95 backdrop-blur-md rounded-2xl p-6 shadow-xl border border-white/20">
            <div className="flex items-center space-x-2 mb-6">
              <div className="w-8 h-8 bg-blue-600 rounded-lg flex items-center justify-center">
                <span className="text-white">🔍</span>
              </div>
              <h3 className="text-xl font-semibold text-slate-800">Bộ lọc nâng cao</h3>
            </div>
            
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
              {/* Search */}
              <div className="space-y-2">
                <label className="block text-sm font-medium text-slate-700">Tìm kiếm</label>
                <input
                  type="text"
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  placeholder="Tìm trong ghi chú hoặc địa chỉ..."
                  className="w-full px-4 py-3 rounded-xl border border-slate-200 focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 bg-white/80"
                />
              </div>
              
              {/* Category */}
              <div className="space-y-2">
                <label className="block text-sm font-medium text-slate-700">Danh mục</label>
                <select
                  value={selectedCategory}
                  onChange={(e) => setSelectedCategory(e.target.value)}
                  className="w-full px-4 py-3 rounded-xl border border-slate-200 focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 bg-white/80"
                >
                  {categories.map(cat => (
                    <option key={cat.id} value={cat.id}>
                      {cat.icon} {cat.name}
                    </option>
                  ))}
                </select>
              </div>
              
              {/* Sort */}
              <div className="space-y-2">
                <label className="block text-sm font-medium text-slate-700">Sắp xếp</label>
                <select
                  value={sortBy}
                  onChange={(e) => setSortBy(e.target.value)}
                  className="w-full px-4 py-3 rounded-xl border border-slate-200 focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 bg-white/80"
                >
                  <option value="newest">Mới nhất</option>
                  <option value="oldest">Cũ nhất</option>
                  <option value="distance">Gần nhất</option>
                </select>
              </div>

              {/* Radius Filter */}
              <div className="space-y-2">
                <label className="block text-sm font-medium text-slate-700">
                  Bán kính: {filterRadius >= 1000 ? `${(filterRadius/1000).toFixed(1)}km` : `${filterRadius}m`}
                </label>
                <input
                  type="range"
                  min="100"
                  max="10000"
                  step="100"
                  value={filterRadius}
                  onChange={(e) => setFilterRadius(Number(e.target.value))}
                  className="w-full h-3 bg-slate-200 rounded-lg appearance-none cursor-pointer slider"
                />
                <div className="flex justify-between text-xs text-slate-500">
                  <span>100m</span>
                  <span>10km</span>
                </div>
              </div>
            </div>

            {currentLocation && (
              <div className="mt-4 p-4 bg-blue-50 rounded-xl">
                <div className="flex items-center space-x-2 text-blue-800">
                  <span>📍</span>
                  <span className="font-medium">Vị trí hiện tại:</span>
                  <span className="font-mono text-sm">
                    {currentLocation.lat.toFixed(6)}, {currentLocation.lng.toFixed(6)}
                  </span>
                  <span className="text-sm">
                    (±{currentLocation.accuracy.toFixed(0)}m)
                  </span>
                </div>
              </div>
            )}
          </div>
        )}

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Note Input Section */}
          <div className="lg:col-span-1">
            <div className="sticky top-24 bg-white/95 backdrop-blur-md rounded-2xl p-6 shadow-xl border border-white/20">
              <div className="flex items-center space-x-2 mb-6">
                <div className="w-8 h-8 bg-blue-600 rounded-lg flex items-center justify-center">
                  <span className="text-white">✍️</span>
                </div>
                <h2 className="text-xl font-semibold text-slate-800">Thêm ghi chú</h2>
              </div>
              
              <div className="space-y-4">
                <textarea
                  value={newNote}
                  onChange={(e) => setNewNote(e.target.value)}
                  placeholder="Nhập nội dung ghi chú của bạn..."
                  rows="4"
                  className="w-full px-4 py-3 rounded-xl border border-slate-200 focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 bg-white/80 resize-none"
                />
                
                {/* Location Status */}
                <div className="flex items-center space-x-2 text-sm">
                  {currentLocation ? (
                    <>
                      <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                      <span className="text-green-700">Vị trí sẵn sàng</span>
                    </>
                  ) : (
                    <>
                      <div className="w-2 h-2 bg-red-500 rounded-full"></div>
                      <span className="text-red-700">Chưa có vị trí</span>
                    </>
                  )}
                </div>
                
                {/* Category Selection */}
                <div className="space-y-3">
                  <label className="block text-sm font-medium text-slate-700">Chọn danh mục</label>
                  <div className="grid grid-cols-2 gap-2">
                    {categories.slice(1).map(cat => (
                      <button
                        key={cat.id}
                        onClick={() => handleCheckIn(cat.id)}
                        disabled={isLoading || !newNote.trim()}
                        className={`${cat.color} hover:opacity-90 disabled:opacity-50 disabled:cursor-not-allowed text-white px-3 py-2 rounded-lg transition-all duration-200 text-sm font-medium flex items-center justify-center space-x-1`}
                      >
                        <span>{cat.icon}</span>
                        <span className="hidden sm:inline">{cat.name}</span>
                      </button>
                    ))}
                  </div>
                </div>
                
                <button 
                  onClick={() => handleCheckIn('other')}
                  disabled={isLoading || !newNote.trim()}
                  className="w-full bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800 disabled:from-gray-400 disabled:to-gray-500 disabled:cursor-not-allowed text-white px-6 py-3 rounded-xl font-medium transition-all duration-200 shadow-lg"
                >
                  {isLoading ? '⏳ Đang lưu ghi chú...' : '📍 Check-in tại đây'}
                </button>

                {!currentLocation && (
                  <p className="text-xs text-slate-500 text-center">
                    Cần có vị trí để tạo ghi chú. Nhấn "Cập nhật vị trí" ở trên.
                  </p>
                )}
              </div>
            </div>
          </div>

          {/* Content Area */}
          <div className="lg:col-span-2">
            {/* Toggle View */}
            <div className="flex justify-center mb-6">
              <div className="bg-white/20 backdrop-blur-sm rounded-xl p-1 border border-white/20">
                <button 
                  onClick={() => setShowMap(false)}
                  className={`px-6 py-3 rounded-lg transition-all duration-200 ${
                    !showMap 
                      ? 'bg-white text-slate-800 shadow-lg' 
                      : 'text-white hover:bg-white/10'
                  }`}
                >
                  📝 Danh sách ({filteredAndSortedNotes.length})
                </button>
                <button 
                  onClick={() => setShowMap(true)}
                  className={`px-6 py-3 rounded-lg transition-all duration-200 ${
                    showMap 
                      ? 'bg-white text-slate-800 shadow-lg' 
                      : 'text-white hover:bg-white/10'
                  }`}
                >
                  🗺️ Bản đồ
                </button>
              </div>
            </div>

            {/* Content Display */}
            {showMap ? (
              <div className="bg-white/95 backdrop-blur-md rounded-2xl p-6 shadow-xl border border-white/20">
                <div className="flex items-center justify-between mb-6">
                  <div className="flex items-center space-x-2">
                    <div className="w-8 h-8 bg-blue-600 rounded-lg flex items-center justify-center">
                      <span className="text-white">🗺️</span>
                    </div>
                    <h2 className="text-xl font-semibold text-slate-800">
                      Bản đồ ghi chú ({filteredAndSortedNotes.length})
                    </h2>
                  </div>
                  
                  {currentLocation && (
                    <button
                      onClick={() => openInMaps(currentLocation.lat, currentLocation.lng, 'Vị trí hiện tại')}
                      className="bg-blue-600 hover:bg-blue-700 text-white px-3 py-2 rounded-lg text-sm transition-all duration-200"
                    >
                      🗺️ Vị trí hiện tại
                    </button>
                  )}
                </div>
                
                {filteredAndSortedNotes.length > 0 ? (
                  <div className="space-y-6">
                    <LeafletMap
                      center={getMapCenter()}
                      zoom={13}
                      notes={filteredAndSortedNotes}
                      currentLocation={currentLocation}
                      onDeleteNote={deleteNote}
                      onOpenMaps={openInMaps}
                      categories={categories}
                    />

                    {/* Map Legend */}
                    <div className="bg-gray-50 rounded-xl p-4">
                      <h4 className="font-semibold text-gray-800 mb-3">Chú thích bản đồ</h4>
                      <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
                        <div className="flex items-center space-x-2">
                          <div className="w-4 h-4 bg-blue-600 rounded-full"></div>
                          <span className="text-sm text-gray-700">Vị trí hiện tại</span>
                        </div>
                        {categories.slice(1).map(cat => {
                          const count = filteredAndSortedNotes.filter(n => n.category === cat.id).length;
                          const colorMap = {
                            'bg-blue-600': '#2563eb',
                            'bg-green-600': '#16a34a',
                            'bg-purple-600': '#9333ea',
                            'bg-orange-600': '#ea580c',
                            'bg-pink-600': '#dc2626',
                            'bg-gray-600': '#4b5563'
                          };
                          return count > 0 ? (
                            <div key={cat.id} className="flex items-center space-x-2">
                              <div 
                                className="w-4 h-4 rounded" 
                                style={{ backgroundColor: colorMap[cat.color] || '#4b5563' }}
                              ></div>
                              <span className="text-sm text-gray-700">{cat.name} ({count})</span>
                            </div>
                          ) : null;
                        })}
                      </div>
                      
                      {/* Map Controls Info */}
                      <div className="mt-4 pt-4 border-t border-gray-200">
                        <div className="flex flex-wrap gap-4 text-xs text-gray-600">
                          <div className="flex items-center space-x-1">
                            <span>🖱️</span>
                            <span>Kéo để di chuyển</span>
                          </div>
                          <div className="flex items-center space-x-1">
                            <span>🔍</span>
                            <span>Scroll để zoom</span>
                          </div>
                          <div className="flex items-center space-x-1">
                            <span>📍</span>
                            <span>Click marker để xem chi tiết</span>
                          </div>
                          {filteredAndSortedNotes.length > 1 && (
                            <div className="flex items-center space-x-1">
                              <span>🎯</span>
                              <span>Bản đồ tự động fit tất cả điểm</span>
                            </div>
                          )}
                        </div>
                      </div>
                    </div>
                  </div>
                ) : (
                  <div className="text-center py-12">
                    <div className="w-24 h-24 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-6">
                      <span className="text-4xl">🗺️</span>
                    </div>
                    <h3 className="text-xl font-semibold text-slate-800 mb-2">Chưa có ghi chú nào</h3>
                    <p className="text-slate-600">Hãy tạo ghi chú đầu tiên để xem trên bản đồ</p>
                  </div>
                )}
              </div>
            ) : (
              <div className="space-y-6">
                {/* Header */}
                <div className="flex justify-between items-center">
                  <div className="flex items-center space-x-3">
                    <div className="w-8 h-8 bg-blue-600 rounded-lg flex items-center justify-center">
                      <span className="text-white">📝</span>
                    </div>
                    <h2 className="text-xl font-semibold text-white">
                      Danh sách ghi chú ({filteredAndSortedNotes.length})
                    </h2>
                  </div>
                  
                  {/* Quick stats */}
                  <div className="hidden sm:flex items-center space-x-4">
                    {currentLocation && (
                      <div className="flex items-center space-x-2 bg-white/10 backdrop-blur-sm rounded-full px-3 py-1">
                        <div className="w-2 h-2 bg-green-500 rounded-full animate-pulse"></div>
                        <span className="text-xs text-slate-300">
                          {currentLocation.lat.toFixed(4)}, {currentLocation.lng.toFixed(4)}
                        </span>
                      </div>
                    )}
                    
                    <div className="flex items-center space-x-2 bg-white/10 backdrop-blur-sm rounded-full px-3 py-1">
                      <span className="text-xs text-slate-300">
                        Bán kính: {filterRadius >= 1000 ? `${(filterRadius/1000).toFixed(1)}km` : `${filterRadius}m`}
                      </span>
                    </div>
                  </div>
                </div>
                
                {filteredAndSortedNotes.length > 0 ? (
                  <div className="grid grid-cols-1 gap-6">
                    {filteredAndSortedNotes.map(note => {
                      const category = categories.find(c => c.id === note.category);
                      const distance = currentLocation ? 
                        Math.round(calculateDistance(currentLocation.lat, currentLocation.lng, note.lat, note.lng)) : null;
                      
                      return (
                        <div key={note.id} className="bg-white/95 backdrop-blur-md rounded-2xl p-6 shadow-lg border border-white/20 hover:shadow-xl transition-all duration-300 group">
                          <div className="flex items-start space-x-4">
                            <div className={`w-12 h-12 ${category?.color} rounded-xl flex items-center justify-center flex-shrink-0 shadow-lg`}>
                              <span className="text-white text-xl">{category?.icon}</span>
                            </div>
                            
                            <div className="flex-1 min-w-0">
                              <div className="flex items-start justify-between mb-4">
                                <div className="flex-1">
                                  <h3 className="text-slate-800 font-semibold text-lg leading-relaxed mb-2">
                                    {note.text}
                                  </h3>
                                  <div className={`inline-flex items-center space-x-1 ${category?.color} text-white px-3 py-1 rounded-full text-xs font-medium`}>
                                    <span>{category?.icon}</span>
                                    <span>{category?.name}</span>
                                  </div>
                                </div>
                                
                                <button 
                                  onClick={() => deleteNote(note.id)}
                                  className="opacity-0 group-hover:opacity-100 bg-red-500 hover:bg-red-600 text-white p-2 rounded-lg transition-all duration-200 ml-4 flex-shrink-0"
                                  title="Xóa ghi chú"
                                >
                                  🗑️
                                </button>
                              </div>
                              
                              <div className="grid grid-cols-1 md:grid-cols-2 gap-3 text-sm text-slate-600 mb-4">
                                <div className="flex items-center space-x-2">
                                  <span className="text-lg">📍</span>
                                  <span className="font-medium">{note.address}</span>
                                </div>
                                <div className="flex items-center space-x-2">
                                  <span className="text-lg">🕒</span>
                                  <span>{new Date(note.timestamp).toLocaleString('vi-VN')}</span>
                                </div>
                                <div className="flex items-center space-x-2">
                                  <span className="text-lg">🎯</span>
                                  <span className="font-mono text-xs">
                                    {note.lat.toFixed(6)}, {note.lng.toFixed(6)}
                                  </span>
                                </div>
                                {distance !== null && (
                                  <div className="flex items-center space-x-2">
                                    <span className="text-lg">📏</span>
                                    <span className="text-blue-600 font-semibold">
                                      Cách {distance >= 1000 ? `${(distance/1000).toFixed(1)}km` : `${distance}m`}
                                    </span>
                                  </div>
                                )}
                                <div className="flex items-center space-x-2">
                                  <span className="text-lg">📊</span>
                                  <span className="text-green-600 font-medium">
                                    Độ chính xác: ±{note.accuracy.toFixed(0)}m
                                  </span>
                                </div>
                              </div>
                              
                              <div className="flex flex-wrap gap-3">
                                <button 
                                  onClick={() => openInMaps(note.lat, note.lng, note.address)}
                                  className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg transition-all duration-200 text-sm font-medium flex items-center space-x-2 shadow-md"
                                >
                                  <span>🗺️</span>
                                  <span>Dẫn đường</span>
                                </button>
                                
                                <button 
                                  onClick={() => {
                                    navigator.clipboard.writeText(`${note.lat}, ${note.lng}`);
                                    alert('Đã copy tọa độ!');
                                  }}
                                  className="bg-gray-600 hover:bg-gray-700 text-white px-4 py-2 rounded-lg transition-all duration-200 text-sm font-medium flex items-center space-x-2"
                                >
                                  <span>📋</span>
                                  <span>Copy tọa độ</span>
                                </button>
                                
                                {distance !== null && distance <= 100 && (
                                  <div className="bg-green-100 text-green-800 px-3 py-2 rounded-lg text-sm font-medium flex items-center space-x-2">
                                    <span>📍</span>
                                    <span>Gần bạn</span>
                                  </div>
                                )}
                              </div>
                            </div>
                          </div>
                        </div>
                      );
                    })}
                  </div>
                ) : (
                  <div className="bg-white/95 backdrop-blur-md rounded-2xl p-12 shadow-xl border border-white/20 text-center">
                    <div className="w-24 h-24 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-6">
                      <span className="text-4xl">📝</span>
                    </div>
                    <h3 className="text-xl font-semibold text-slate-800 mb-3">
                      {searchTerm || selectedCategory !== 'all' 
                        ? 'Không tìm thấy ghi chú phù hợp' 
                        : 'Chưa có ghi chú nào'
                      }
                    </h3>
                    <p className="text-slate-600 mb-4">
                      {searchTerm || selectedCategory !== 'all' 
                        ? 'Thử điều chỉnh bộ lọc hoặc từ khóa tìm kiếm' 
                        : 'Hãy tạo ghi chú đầu tiên của bạn với vị trí hiện tại'
                      }
                    </p>
                    
                    {(searchTerm || selectedCategory !== 'all') && (
                      <div className="flex justify-center space-x-3">
                        <button
                          onClick={() => {
                            setSearchTerm('');
                            setSelectedCategory('all');
                          }}
                          className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg transition-all duration-200"
                        >
                          🔄 Xóa bộ lọc
                        </button>
                      </div>
                    )}
                  </div>
                )}
              </div>
            )}
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="bg-black/50 backdrop-blur-sm border-t border-white/10 py-8 mt-12">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center">
            <div className="flex items-center justify-center space-x-2 mb-4">
              <div className="w-6 h-6 bg-blue-500 rounded-lg flex items-center justify-center">
                <span className="text-white text-sm">📍</span>
              </div>
              <span className="text-white font-medium">Geo-Notes</span>
            </div>
            <p className="text-slate-400 text-sm mb-4">
              Ứng dụng ghi chú thông minh theo vị trí - Lưu trữ kỷ niệm của bạn với GPS
            </p>
            <div className="flex justify-center space-x-6 text-xs text-slate-500">
              <span>📱 Responsive Design</span>
              <span>🗺️ Maps Integration</span>
              <span>📍 GPS Location</span>
              <span>💾 Auto Save</span>
            </div>
          </div>
        </div>
      </footer>

      <style jsx>{`
        .slider::-webkit-slider-thumb {
          appearance: none;
          height: 20px;
          width: 20px;
          border-radius: 50%;
          background: #2563eb;
          cursor: pointer;
          border: 2px solid white;
          box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
        }

        .slider::-moz-range-thumb {
          height: 20px;
          width: 20px;
          border-radius: 50%;
          background: #2563eb;
          cursor: pointer;
          border: 2px solid white;
          box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
        }

        .slider::-webkit-slider-track {
          height: 8px;
          background: #e2e8f0;
          border-radius: 4px;
        }

        .slider::-moz-range-track {
          height: 8px;
          background: #e2e8f0;
          border-radius: 4px;
          border: none;
        }
      `}</style>
    </div>
  );
}

export default App;