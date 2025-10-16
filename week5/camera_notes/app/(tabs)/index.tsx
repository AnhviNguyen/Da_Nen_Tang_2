import { Button } from '@/components/ui/button';
import { usePhotoStorage } from '@/hooks/useStorage';
import { CameraType, CameraView, useCameraPermissions } from 'expo-camera';
import { useEffect, useRef, useState } from 'react';
import { ActivityIndicator, Pressable, StyleSheet, Text, TextInput, View } from 'react-native';

export default function HomeScreen() {
  const cameraRef = useRef<CameraView>(null);
  const [permission, requestPermission] = useCameraPermissions();
  const [type, setType] = useState<CameraType>('back');
  const [capturing, setCapturing] = useState(false);
  const [caption, setCaption] = useState('');
  const [showCaption, setShowCaption] = useState(false);
  const [torchOn, setTorchOn] = useState(false);
  const { addPhoto } = usePhotoStorage();

  useEffect(() => {
    if (!permission?.granted) requestPermission();
  }, [permission, requestPermission]);

  if (!permission) {
    return (
      <View style={styles.centered}><ActivityIndicator /></View>
    );
  }

  if (!permission.granted) {
    return (
      <View style={[styles.centered, { padding: 24 }]}> 
        <Text style={{ fontSize: 18, fontWeight: '600', marginBottom: 12 }}>Cho phép truy cập camera</Text>
        <Text style={{ textAlign: 'center', color: '#4b5563', marginBottom: 16 }}>
          Ứng dụng cần quyền Camera để chụp ảnh và lưu ghi chú.
        </Text>
        <Button label="Cấp quyền" onPress={requestPermission} />
      </View>
    );
  }

  const onCapture = async () => {
    if (!cameraRef.current || capturing) return;
    try {
      setCapturing(true);
      const result = await cameraRef.current.takePictureAsync({ quality: 0.9, skipProcessing: true });
      if (result?.uri) {
        await addPhoto({ tempUri: result.uri, caption });
        setCaption('');
        setShowCaption(false);
      }
    } finally {
      setCapturing(false);
    }
  };

  return (
    <View style={{ flex: 1, backgroundColor: '#000' }}>
      {/* Header overlay */}
      <View style={styles.headerBar}>
          <View style={styles.headerIcons}>
            <View style={styles.iconCircle}><Text style={styles.iconText}>↻</Text></View>
          </View>
      </View>

      {/* Center camera frame only */}
      <View style={styles.previewCard}>
        <CameraView ref={cameraRef} style={{ flex: 1 }} facing={type} enableTorch={torchOn && type === 'back'} />
        {showCaption && (
          <View style={styles.captionBubble}>
            <Text numberOfLines={2} style={{ color: '#fff', fontWeight: '700' }}>{caption || ' '}</Text>
          </View>
        )}
      </View>

      {/* Bottom controls overlay */}
      <View style={styles.bottomBar}>
          <View style={styles.messageBar}>
            {showCaption ? (
              <TextInput
                placeholder="Nhập caption..."
                placeholderTextColor="#9ca3af"
                value={caption}
                onChangeText={setCaption}
                style={styles.input}
              />
            ) : (
              <Pressable onPress={() => setShowCaption(true)}>
                <Text style={{ color: '#9ca3af' }}>Send message...</Text>
              </Pressable>
            )}
          </View>

          <View style={styles.controlsRow}>
            <Pressable
              onPress={() => { setType((t) => (t === 'back' ? 'front' : 'back')); setTorchOn(false); }}
              style={styles.smallCircle}
            >
              <Text style={styles.iconText}>↺</Text>
            </Pressable>
            <Pressable onPress={onCapture} style={styles.bigShutter}>
              {capturing ? <ActivityIndicator color="#111827" /> : null}
            </Pressable>
            <Pressable onPress={() => setTorchOn((v) => !v)} style={[styles.smallCircle, torchOn && { backgroundColor: '#fde047' }]}>
              <Text style={[styles.iconText, torchOn && { color: '#111827' }]}>⚡</Text>
            </Pressable>
          </View>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  centered: { flex: 1, alignItems: 'center', justifyContent: 'center' },
  headerBar: {
    position: 'absolute',
    top: 16,
    left: 16,
    right: 16,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  audienceChip: {
    backgroundColor: 'rgba(0,0,0,0.5)',
    borderRadius: 18,
    paddingHorizontal: 12,
    paddingVertical: 8,
  },
  headerIcons: { flexDirection: 'row', gap: 10 },
  iconCircle: {
    width: 36,
    height: 36,
    borderRadius: 18,
    backgroundColor: 'rgba(0,0,0,0.5)',
    alignItems: 'center',
    justifyContent: 'center',
  },
  iconText: { color: '#111827', fontWeight: '700' },
  previewCard: {
    position: 'absolute',
    top: '18%',
    left: 16,
    right: 16,
    borderRadius: 22,
    overflow: 'hidden',
    height: '45%',
    backgroundColor: '#111',
  },
  captionBubble: {
    position: 'absolute',
    bottom: 12,
    left: 12,
    right: 12,
    paddingHorizontal: 12,
    paddingVertical: 10,
    backgroundColor: 'rgba(0,0,0,0.6)',
    borderRadius: 14,
  },
  bottomBar: {
    position: 'absolute',
    left: 0,
    right: 0,
    bottom: 0,
    padding: 16,
    gap: 10,
  },
  messageBar: {
    backgroundColor: 'rgba(255,255,255,0.08)',
    borderRadius: 20,
    paddingHorizontal: 14,
    paddingVertical: 12,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
  },
  input: { color: '#fff', flex: 1 },
  emoji: { fontSize: 18 },
  controlsRow: {
    marginTop: 8,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  smallCircle: {
    width: 56,
    height: 56,
    borderRadius: 28,
    backgroundColor: '#e5e7eb',
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 2,
    borderColor: '#ffffff22',
  },
  bigShutter: {
    width: 88,
    height: 88,
    borderRadius: 44,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 6,
    borderColor: '#e5e7eb',
  },
});
